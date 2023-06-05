
resource "aws_dynamodb_table" "rides" {
  name           = "Rides"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "RideId"
  attribute {
    name = "RideId"
    type = "S"
  }
}