data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["github-iac"]
    }

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.execution_account_id}:role/GitHub-IaC-Provisioning"]
    }
  }
}

data "aws_iam_policy_document" "role_policy" {

  statement {
    sid = "ECRRead"
    actions = [
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListTagsForResource",
    ]

    resources = [
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/xpanse-ims/*",
    ]
  }

  statement {
    sid = "ECRWrite"
    actions = [
      "ecr:DeleteRepository",
      "ecr:DeleteRepositoryPolicy",
      "ecr:SetRepositoryPolicy",
      "ecr:TagResource",
    ]

    resources = [
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/xpanse-ims/*",
    ]
  }

  statement {
    sid = "CodeArtifactRead"
    actions = [
      "codeartifact:DescribeDomain",
      "codeartifact:DescribeRepository",
      "codeartifact:GetDomainPermissionsPolicy",
      "codeartifact:GetRepositoryPermissionsPolicy",
      "codeartifact:ListTagsForResource",
    ]

    resources = [
      "arn:aws:codeartifact:${var.region}:${var.account_id}:repository/xpanse/*",
      "arn:aws:codeartifact:${var.region}:${var.account_id}:domain/xpanse",
    ]
  }

  statement {
    sid = "CodeArtifactWrite"
    actions = [
      "codeartifact:AssociateExternalConnection",
      "codeartifact:AssociateWithDownstreamRepository",
      "codeartifact:DeleteDomain",
      "codeartifact:DeleteRepository",
      "codeartifact:PutDomainPermissionsPolicy",
      "codeartifact:PutRepositoryPermissionsPolicy",
      "codeartifact:TagResource",
      "codeartifact:UntagResource",
    ]

    resources = [
      "arn:aws:codeartifact:${var.region}:${var.account_id}:repository/xpanse/*",
      "arn:aws:codeartifact:${var.region}:${var.account_id}:domain/xpanse",
    ]
  }

  statement {
    sid = "S3ObjectsRead"

    actions = [
      "s3:GetObjectVersionTagging",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectAttributes",
      "s3:GetObjectRetention",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionAttributes",
    ]

    resources = [
      "arn:aws:s3:::ims-*/*",
    ]
  }

  statement {
    sid = "S3ObjectsWrite"
    actions = [
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectVersionAcl",
    ]

    resources = [
      "arn:aws:s3:::ims-*/*",
    ]
  }

  statement {
    sid = "IAMRead"
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
    ]

    resources = [
      "arn:aws:iam::${var.account_id}:role/*",
    ]
  }

  statement {
    sid = "IAMWrite"
    actions = [
      "iam:CreateOpenIDConnectProvider",
      "iam:CreateRole",
      "iam:DeleteOpenIDConnectProvider",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:GetOpenIDConnectProvider",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:TagOpenIDConnectProvider",
      "iam:TagRole",
      "iam:UpdateAssumeRolePolicy",
    ]

    resources = [
      "arn:aws:iam::${var.account_id}:oidc-provider/token.actions.githubusercontent.com",
      "arn:aws:iam::${var.account_id}:role/*",
    ]
  }

  statement {
    sid = "KMS"
    actions = [
      "kms:CreateAlias",
      "kms:CreateGrant",
      "kms:DeleteAlias",
      "kms:DescribeKey",
      "kms:EnableKeyRotation",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "kms:PutKeyPolicy",
      "kms:ScheduleKeyDeletion",
      "kms:TagResource",
    ]

    resources = [
      "arn:aws:kms:*:${var.account_id}:key/*",
      "arn:aws:kms:*:${var.account_id}:alias/*",
    ]
  }

  statement {
    # Actions in this statement require all resources
    sid = "AllResources"

    actions = [
      "codeartifact:CreateDomain",
      "codeartifact:CreateRepository",
      "ecr:BatchImportUpstreamImage",
      "ecr:CreatePullThroughCacheRule",
      "ecr:CreateRepository",
      "ecr:DeletePullThroughCacheRule",
      "ecr:DeleteRegistryPolicy",
      "ecr:DescribePullThroughCacheRules",
      "ecr:DescribeRegistry",
      "ecr:GetAuthorizationToken",
      "ecr:GetRegistryPolicy",
      "ecr:GetRegistryScanningConfiguration",
      "ecr:PutRegistryPolicy",
      "ecr:PutRegistryScanningConfiguration",
      "ecr:PutReplicationConfiguration",
      "kms:CreateKey",
      "kms:ListAliases",
      "s3:ListAllMyBuckets",
      "s3:PutAccountPublicAccessBlock",
    ]

    resources = [
      "*"
    ]
  }

}

module "role_with_inline_policy" {
  source                      = "tfregistry.xpanse.com/xpanse-tf-reg__shared/iam-role-with-inline-policy/aws"
  version                     = "v2.3.0"
  role_name                   = "GitHub-IaC-Provisioning"
  description                 = "Assumed role for execution from Github IaC workflows."
  project                     = "IMS Infra Base"
  policy_document             = data.aws_iam_policy_document.role_policy
  assume_role_policy_document = data.aws_iam_policy_document.assume_role_policy
}
