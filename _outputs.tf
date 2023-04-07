output "efs_file_system_id" {
  description = "The id of the EFS file system created by this module."
  value       = aws_efs_file_system.efs.id
}
