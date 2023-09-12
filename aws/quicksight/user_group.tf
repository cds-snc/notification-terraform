resource "aws_quicksight_group" "dataset_owner" {
  group_name  = "quicksight-dataset-owners"
  description = "users with owner permissions to QuickSight data sets"
}

resource "aws_quicksight_group" "dataset_viewer" {
  group_name  = "quicksight-dataset-viewers"
  description = "users with viewer permissions to QuickSight data sets"
}
