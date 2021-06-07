class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.github.io/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/1.6.0.tar.gz"
  sha256 "b643fbcf5cd604fe2284e3de870140aac6d03b14651b61d792002e879aea6b45"
  head "https://github.com/tamarin-prover/tamarin-prover.git", branch: "develop"

  bottle do
    root_url "https://github.com/tamarin-prover/tamarin-prover/releases/download/1.6.0"
    # Looking at docs might be able to use :sierra_or_later
    sha256 cellar: :any_skip_relocation, catalina:     "37af72ed0cb070682c278a7e0298c3a17f5938e3a86e38b31a56900e50798717"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c96a2ad6f0cb8eb29a51b1c33896732185cd770876fc3ccb16710f0889a96a9f"
  end

  depends_on "haskell-stack" => :build
  depends_on "zlib" => :build unless OS.mac?
  depends_on "ocaml" => :build
  depends_on "graphviz"
  depends_on macos: :yosemite
  depends_on "maude"

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    system "stack", "-j#{jobs}", "setup"
    args = []
    unless OS.mac?
      args << "--extra-include-dirs=#{Formula["zlib"].include}" << "--extra-lib-dirs=#{Formula["zlib"].lib}"
    end
    system "stack", "-j#{jobs}", *args, "install", "--flag", "tamarin-prover:threaded"

    # `ocaml` building under linuxbrew needs to be single core.
    ENV.deparallelize
    system "make", "sapic"

    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end
