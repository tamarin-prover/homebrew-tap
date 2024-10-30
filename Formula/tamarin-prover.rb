class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.com/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/refs/tags/1.10.0.tar.gz"
  sha256 "d747e4922aac682f7afce92a63fd7f556e20b1678b1877f3a6281ae899f79767"
  head "https://github.com/tamarin-prover/tamarin-prover.git", branch: "master"

  bottle do
    root_url "https://github.com/tamarin-prover/tamarin-prover/releases/download/1.10.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "68547fe682b5bc86c8549c1be8585814f2d503193ea9d297f584181d64070385"
#    sha256 cellar: :any_skip_relocation, x86_64_linux: "dfc65b2f87d237048031d9e96824254c5cd26539e83c5690fca30680993b3793"
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
