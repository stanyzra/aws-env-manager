class EnvManager < Formula
    include Language::Python::Virtualenv

    desc "A environment variable manager for AWS Amplify and ECS, initially designed for Collection"
    homepage "https://github.com/stanyzra/homebrew-aws-env-manager"
    url "https://github.com/stanyzra/homebrew-aws-env-manager/archive/refs/tags/v1.0.0.tar.gz"
    sha256 "ba91acd8a39bd32cf17129a55f5490ce7cfcb59ec509d5d4f0264b6eee0c868e"
    license "Apache-2.0"
    head "https://github.com/stanyzra/homebrew-aws-env-manager.git", branch: "main"

    depends_on "python@3.10"

    # resource "boto3" do
    #     url "https://files.pythonhosted.org/packages/bf/cd/8e6468c2f462ebcd6629b4b0ff4c114b0266a06bcb5cbc958ae1db6dcfff/boto3-1.34.72.tar.gz"
    #     sha256 "cbfabd99c113bbb1708c2892e864b6dd739593b97a76fbb2e090a7d965b63b82"
    # end
        
    # resource "botocore" do
    #     url "https://files.pythonhosted.org/packages/46/09/53419321db64184c34a700bc0951fdae752f236d6d2bb6be3fa3586cfd47/botocore-1.34.72.tar.gz"
    #     sha256 "342edb6f91d5839e790411822fc39f9c712c87cdaa7f3b1999f50b1ca16c4a14"
    # end
         
    def install
        venv = virtualenv_create(libexec, "python3")
        venv.pip_install resources
        venv.pip_install_and_link buildpath
        bin.install_symlink libexec/"bin/env_manager"
    end

    test do
    system bin/"env_manager", "--help"
    end
end
