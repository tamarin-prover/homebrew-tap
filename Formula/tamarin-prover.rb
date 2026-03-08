class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.com/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/refs/tags/1.12.0.tar.gz"
  sha256 "35f0262e770db3632fcb297deb6ecc2d7c724c693fecfe97892e8224fa161956"
  head "https://github.com/tamarin-prover/tamarin-prover.git", branch: "master"

  bottle do
    root_url "https://github.com/tamarin-prover/tamarin-prover/releases/download/1.12.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "6ca9238e5ed0ed1816797c4876b2e7c21d90d4133d69e8e474749c8125b16632"
  end

  depends_on "haskell-stack" => :build
  depends_on "zlib" => :build unless OS.mac?
  depends_on "npm" => :build
  depends_on "graphviz"
  depends_on "maude"
  depends_on "npm" => :build

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # just call make
    system "make"
    # # Let `stack` handle its own parallelization
    # jobs = ENV.make_jobs
    # system "stack", "-j#{jobs}", "setup"
    # args = []
    # unless OS.mac?
    #   args << "--extra-include-dirs=#{Formula["zlib"].include}" << "--extra-lib-dirs=#{Formula["zlib"].lib}"
    # end
    # system "stack", "-j#{jobs}", *args, "install", "--flag", "tamarin-prover:threaded"

    # `ocaml` building under linuxbrew needs to be single core.
    # ENV.deparallelize
    # system "make", "sapic"

    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end
