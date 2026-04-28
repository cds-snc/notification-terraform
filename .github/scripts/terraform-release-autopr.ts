import { execSync } from "node:child_process";
import { appendFileSync, readFileSync, writeFileSync } from "node:fs";

const INFRA_VERSION_PATH = ".github/workflows/infrastructure_version.txt";
const MAX_COMMITS_IN_SUMMARY = 25;

function run(command: string): string {
  return execSync(command, { encoding: "utf8" }).trim();
}

function setOutput(name: string, value: string): void {
  const outputFile = process.env.GITHUB_OUTPUT;

  if (!outputFile) {
    console.log(`${name}=${value}`);
    return;
  }

  const multiline = value.includes("\n");
  if (!multiline) {
    appendFileSync(outputFile, `${name}=${value}\n`);
    return;
  }

  const delimiter = `EOF_${name.toUpperCase()}`;
  appendFileSync(outputFile, `${name}<<${delimiter}\n${value}\n${delimiter}\n`);
}

function tagExists(tag: string): boolean {
  if (!tag) {
    return false;
  }

  try {
    run(`git rev-parse --verify --quiet refs/tags/${tag}`);
    return true;
  } catch {
    return false;
  }
}

function collectCommitLines(fromTag: string, toTag: string): string[] {
  try {
    const range = tagExists(fromTag) ? `${fromTag}..${toTag}` : toTag;
    const output = run(`git log --oneline --no-decorate -n ${MAX_COMMITS_IN_SUMMARY} ${range}`);

    if (!output) {
      return [];
    }

    return output
      .split("\n")
      .map((line) => line.trim())
      .filter(Boolean);
  } catch {
    return [];
  }
}

function toMarkdownCommitList(lines: string[], repo: string): string {
  if (lines.length === 0) {
    return "- No commit summary available.";
  }

  return lines
    .map((line) => {
      const firstSpace = line.indexOf(" ");
      if (firstSpace <= 0) {
        return `- ${line}`;
      }

      const hash = line.slice(0, firstSpace);
      const message = line.slice(firstSpace + 1);
      return `- [${hash}](https://github.com/${repo}/commit/${hash}) ${message}`;
    })
    .join("\n");
}

function main(): void {
  const repository = process.env.GITHUB_REPOSITORY ?? "cds-snc/notification-terraform";
  const currentVersion = readFileSync(INFRA_VERSION_PATH, "utf8").trim();
  const latestTag = run("git tag --sort=-v:refname | head -n 1");

  if (!latestTag) {
    throw new Error("No git tags found. Cannot generate Terraform release auto-PR.");
  }

  setOutput("current_version", currentVersion);
  setOutput("target_version", latestTag);

  if (currentVersion === latestTag) {
    setOutput("should_create_pr", "false");
    setOutput("reason", "infrastructure_version already matches latest tag");
    return;
  }

  writeFileSync(INFRA_VERSION_PATH, `${latestTag}\n`, "utf8");

  const commitLines = collectCommitLines(currentVersion, latestTag);
  const commitSummary = toMarkdownCommitList(commitLines, repository);
  const prTitle = `[AUTO-PR] Terraform production release ${currentVersion} -> ${latestTag}`;
  const commitMessage = `[AUTO-PR] Bump infrastructure_version ${currentVersion} -> ${latestTag}`;
  const branchName = `auto-pr/terraform-release-${latestTag.replace(/[^a-zA-Z0-9._-]/g, "-")}`;

  const prBody = [
    "# Summary | Resume",
    `Update production Terraform release version in \`${INFRA_VERSION_PATH}\` from \`${currentVersion}\` to \`${latestTag}\`.`,
    "",
    "## Change summary",
    commitSummary,
    "",
    "## Test instructions | Instructions pour tester la modification",
    "- [ ] Verify the generated version bump matches the latest Terraform tag.",
    "- [ ] Verify production terragrunt plan uses the new version value.",
    "",
    "## Release Instructions | Instructions pour le deploiement",
    "None.",
  ].join("\n");

  setOutput("should_create_pr", "true");
  setOutput("branch_name", branchName);
  setOutput("pr_title", prTitle);
  setOutput("commit_message", commitMessage);
  setOutput("pr_body", prBody);
}

main();
