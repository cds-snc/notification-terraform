resource "aws_quicksight_group" "dataset_full" {
  group_name  = "quicksight-dataset-full-access"
  description = "users with full access to Quicksight data sets"
}

resource "aws_quicksight_group" "dataset_viewer" {
  group_name  = "quicksight-dataset-viewer-access"
  description = "users with viewer access to Quicksight data sets"
}
