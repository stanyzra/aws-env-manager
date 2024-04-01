class EnvManager < Formula
    include Language::Python::Virtualenv

    desc "A environment variable manager for AWS Amplify and ECS, initially designed for Collection"
    homepage "https://github.com/stanyzra/homebrew-aws-env-manager"
    url "https://github.com/stanyzra/homebrew-aws-env-manager/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "1f85729c6273045ef3dc824ff2ca289f977418798098e3325992952bbdb7979e"
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
        
    resource "parsedatetime" do
        url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
        sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
    end

    resource "jmespath" do
        url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
        sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
    end

    resource "prompt-toolkit" do
        url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
        sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
    end

    resource "python-dateutil" do
        url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
        sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
    end

    resource "six" do
        url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
        sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
    end

    resource "urllib3" do
        url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
        sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
    end

    resource "wcwidth" do
        url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
        sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
    end
         
    def install
        virtualenv_install_with_resources
    end

    test do
        system bin/"env_manager", "--help"
    end
end
