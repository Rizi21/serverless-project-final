resource "aws_dynamodb_table" "rides" {
  name           = "Rides"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "RideId"
    type = "S"
  }

  key {
    attribute_name = "RideId"
    key_type       = "HASH"
  }
}