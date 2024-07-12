import argparse
import subprocess
import os


def main():
  
  parser = argparse.ArgumentParser()

  parser.add_argument('-e', "--environment",)    
  parser.add_argument('-a', "--action",)    

  args = parser.parse_args()
  environment = args.environment
  action = args.action
  print(environment + " " + action)
  
  checkEnvVars()
  runTerragrunt(environment, action)

def runTerragrunt(environment, action):

  my_env = os.environ.copy()
  my_env["ENVIRONMENT"] = environment
  command = "terragrunt " + action
  subprocess.call(command, shell=True, env=my_env)
  print(command)

def checkEnvVars():
   
  command = "op read \"op://4eyyuwddp6w4vxlabrr2i2duxm/Ben - Dev.hcl/notesPlain\" > /var/tmp/secret.hcl"
  subprocess.run(command, 
                 shell=True,
                 stdout = subprocess.DEVNULL)

  with open("../../env/dev.hcl","r") as localFile:
    localSecrets = localFile.read()
  
  with open("/var/tmp/secret.hcl","r") as remoteFile:
    remoteSecrets = remoteFile.read()

  if localSecrets == remoteSecrets:
    print("Local and remote secrets are the same.")
  else:
    print("Local and remote secrets are different. What would you like to do?")
    response = input("push/pull/ignore/quit\n")

    match response:
      case "push":
        pushSecrets(localSecrets)
      case "pull":
        pullSecrets(remoteSecrets)
      case "ignore":
        print("Ignoring differences.")
      case "quit":
        exit(0)
    
def pushSecrets(localSecrets):
  print("Updating secrets.")
  
  command = "op item edit \"Ben - Dev.hcl\" notesPlain='" + localSecrets + "'"
  subprocess.run(command, 
                shell=True,
                stdout = subprocess.DEVNULL)

def pullSecrets(remoteSecrets):
  print("Syncing Secrets")
  localFile = open("../../env/dev.hcl", "w")
  localFile.write(remoteSecrets)
  localFile.close()

if __name__ == "__main__":
    main()


