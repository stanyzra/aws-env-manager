class EnvManager < Formula
    include Language::Python::Virtualenv

    desc "A environment variable manager for AWS Amplify and ECS, initially designed for Collection"
    homepage "https://github.com/stanyzra/homebrew-aws-env-manager"
    url "https://github.com/stanyzra/homebrew-aws-env-manager/archive/refs/tags/v1.0.3.tar.gz"
    sha256 "111398df7976397e331f2fda4afb82f417bd9ae0232fb26c15cb9314c2b17d63"
    license "Apache-2.0"
    head "https://github.com/stanyzra/homebrew-aws-env-manager.git", branch: "main"

    depends_on "python@3.10"

    resource "boto3" do
        url "https://files.pythonhosted.org/packages/bf/cd/8e6468c2f462ebcd6629b4b0ff4c114b0266a06bcb5cbc958ae1db6dcfff/boto3-1.34.72.tar.gz"
        sha256 "cbfabd99c113bbb1708c2892e864b6dd739593b97a76fbb2e090a7d965b63b82"
    end
        
    resource "botocore" do
        url "https://files.pythonhosted.org/packages/46/09/53419321db64184c34a700bc0951fdae752f236d6d2bb6be3fa3586cfd47/botocore-1.34.72.tar.gz"
        sha256 "342edb6f91d5839e790411822fc39f9c712c87cdaa7f3b1999f50b1ca16c4a14"
    end
         
    resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end
         
    def install
        virtualenv_install_with_resources
    end

    test do
        system bin/"env_manager", "--help"
    end
end
