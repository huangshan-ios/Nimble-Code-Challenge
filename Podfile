platform :ios, '10.0'

RXSWIFT_VERSION = '6.5.0'
RXCOCOA_VERSION = '6.5.0'
RXTEST_VERSION = '6.5.0'
RXBLOCKING_VERSION = '6.5.0'
MOYA_VERSION = '~> 15.0'

def project_dependency
  pod 'RxSwift', RXSWIFT_VERSION
  pod 'RxCocoa', RXCOCOA_VERSION
  pod 'Moya/RxSwift', MOYA_VERSION
end

def test_depdendency 
  pod 'RxBlocking', RXTEST_VERSION
  pod 'RxTest', RXBLOCKING_VERSION
end

target 'Nimble-Code-Challenge' do
  use_frameworks!

  project_dependency

  target 'Nimble-Code-ChallengeTests' do
    inherit! :search_paths
    test_depdendency
  end

end
