class Libbuddy < Formula
  desc "Binary decision diagram library"
  homepage "https://sourceforge.net/projects/buddy/"
  url "https://downloads.sourceforge.net/project/buddy/buddy/BuDDy%202.4/buddy-2.4.tar.gz"
  sha256 "d3df80a6a669d9ae408cb46012ff17bd33d855529d20f3a7e563d0d913358836"

  bottle do
    root_url "https://github.com/tamarin-prover/binaries/blob/main/dependencies"
    rebuild 3
    sha256 cellar: :any_skip_relocation, big_sur:      "2d2c92c55832c9f6ba160cc9154542779a63ab111bb8bc668f295e776dc1ab9a"
    sha256 cellar: :any_skip_relocation, catalina:     "be9577ed9a01c80b48f459a08c60e6a27813a5131e5a735855a41205dffc00a3"
    sha256 cellar: :any_skip_relocation, high_sierra:  "5c150e653aeb36ce34381f24137c963419a169e665cdfa5e6f15495923beb694"
    sha256 cellar: :any_skip_relocation, el_capitan:   "5dc396c196d46646102d10c5d3ff32d8b37249cac78af2595417e6474494453b"
    sha256 cellar: :any_skip_relocation, yosemite:     "451c34f54e575578a3b3cfaad5e5a860f012317ff32053097c6132bba60a7da9"
    sha256 cellar: :any_skip_relocation, mavericks:    "f4a66068fc8b53b557e3c9f6be57574c1711aedd91e1f18e2b6c5111b62fdbe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0807d5706dc37213dbc466b06819fc1b93d710c3543b92eec3c07e7c4fc317d5"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include "bvec.h"
      using namespace std;
      int main(void) {
        bdd_init(10, 10);
        bvec x = bvec(1);
        bvec c = bvec(1, 0);
        bdd t = x == c;
        cout << t;
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cc", "-I#{include}", "-L#{lib}", "-lbdd"
    assert_equal "T", shell_output("./test")
  end
end
