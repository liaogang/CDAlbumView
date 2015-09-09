Pod::Spec.new do |s|
  s.platform = :ios, '6.0'
  s.name     = 'CDAlbumView'
  s.version  = '1.0.3'
  s.license  = 'MIT'
  s.summary  = "A ios View Controller for displaying a rotating music album picture."
  s.homepage = 'https://github.com/liaogang/CDAlbumView'
  s.authors  = { 'liaogagng' => 'ynwlgh@icloud.com' }
  s.source   = { :git => 'https://github.com/liaogang/CDAlbumView.git', :tag => 'v1.0.3'  }
  s.source_files = 'CDAlbumView'
  s.resources = "CDAlbumView/*.png","CDAlbumView/CDAlbum.storyboard"
  s.dependency 'SDWebImage', '~> 3.7.3'
end

