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
        
    resource "parsedatetime" do
        url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
        sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
    end

    resource "cffi" do
        url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
        sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
    end

    resource "colorama" do
        url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
        sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
    end

    resource "cryptography" do
        url "https://files.pythonhosted.org/packages/15/d9/c679e9eda76bfc0d60c9d7a4084ca52d0631d9f24ef04f818012f6d1282e/cryptography-40.0.1.tar.gz"
        sha256 "2803f2f8b1e95f614419926c7e6f55d828afc614ca5ed61543877ae668cc3472"
    end

    resource "distro" do
        url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
        sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
    end

    resource "docutils" do
        url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
        sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
    end

    resource "jmespath" do
        url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
        sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
    end

    resource "prompt-toolkit" do
        url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
        sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
    end

    resource "pycparser" do
        url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
        sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
    end

    resource "python-dateutil" do
        url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
        sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
    end

    resource "ruamel-yaml" do
        url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
        sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
    end

    resource "ruamel-yaml-clib" do
        url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
        sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
    end

    resource "setuptools" do
        url "https://files.pythonhosted.org/packages/4d/5b/dc575711b6b8f2f866131a40d053e30e962e633b332acf7cd2c24843d83d/setuptools-69.2.0.tar.gz"
        sha256 "0ff4183f8f42cd8fa3acea16c45205521a4ef28f73c6391d8a25e92893134f2e"
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

    resource "wheel" do
        url "https://files.pythonhosted.org/packages/b8/d6/ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69/wheel-0.43.0.tar.gz"
        sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
    end

         
    def install
        virtualenv_install_with_resources
    end

    test do
        system bin/"env_manager", "--help"
    end
end
