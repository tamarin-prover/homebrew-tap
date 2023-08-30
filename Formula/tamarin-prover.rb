class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/refs/tags/1.8.0.tar.gz"
  sha256 "0c6433c461acfc675dd9437653322b8cfe6cd5fac1a14d034da8430afe1e090f"
  head "https://github.com/tamarin-prover/tamarin-prover.git", branch: "master"

  bottle do
    root_url "https://github.com/tamarin-prover/tamarin-prover/releases/download/1.8.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dfc65b2f87d237048031d9e96824254c5cd26539e83c5690fca30680993b3793"
    #sha256 cellar: :any,                 arm64_monterey: "34269ddaada7f142817c4aeb38dcc223b58ff42ab719d7c0447fd0dc8da9dbd2"
    #sha256 cellar: :any_skip_relocation, big_sur:        "a886014d7c2345bc2f2ea1836dd9bf1199435fcec54963f8e07e80e13fe857c6"
    #sha256 cellar: :any_skip_relocation, catalina:       "b8a142ad4961d0beb06c9c4912baacca6deb7870016a22183e40dc259e60d500"
  end

  depends_on "haskell-stack" => :build
  depends_on "zlib" => :build unless OS.mac?
  depends_on "ocaml" => :build
  depends_on "graphviz"
  depends_on "maude"

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    system "stack", "-j#{jobs}", "setup"
    args = []
    # Temporary fix for GHC 9.0.2 issue, see https://gitlab.haskell.org/ghc/ghc/-/issues/20592
    #if Hardware::CPU.arm? && OS.mac?
    #  ENV["C_INCLUDE_PATH"] =
    #    "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/ffi"
    #end
    unless OS.mac?
      args << "--extra-include-dirs=#{Formula["zlib"].include}" << "--extra-lib-dirs=#{Formula["zlib"].lib}"
    end
    system "stack", "-j#{jobs}", *args, "install", "--flag", "tamarin-prover:threaded"

    # `ocaml` building under linuxbrew needs to be single core.
    # ENV.deparallelize
    # system "make", "sapic"

    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end
