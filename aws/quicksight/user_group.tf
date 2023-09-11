resource "aws_quicksight_group" "dataset_full" {
  group_name  = "quicksight-dataset-full-access"
  description = "users with full access to Quicksight data sets"
}
