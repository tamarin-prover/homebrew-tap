class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/refs/tags/1.8.0.tar.gz"
  sha256 "0c6433c461acfc675dd9437653322b8cfe6cd5fac1a14d034da8430afe1e090f"
  head "https://github.com/tamarin-prover/tamarin-prover.git", branch: "master"

  bottle do
    root_url "https://github.com/tamarin-prover/tamarin-prover/releases/download/1.8.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dfc65b2f87d237048031d9e96824254c5cd26539e83c5690fca30680993b3793"
    sha256 cellar: :any_skip_relocation, big_sur: "5648b96066e5a217f435778fb78cc5d426efd75897b60f5d1f1686d393225222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f02e73eb3e966a8546455b143880727237ee45e8287577f095771c2f13f9b0df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "449c36cff1f1b6ec80463258dcf3c4cce1a195ade84a7b1483ab2ab04c747a1f"
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
