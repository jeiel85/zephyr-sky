import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스가 비활성화되어 있습니다. 설정에서 활성화해 주세요.');
    }

    // 위치 권한 확인 및 요청
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 영구적으로 거부되었습니다. 설정에서 직접 허용해 주세요.');
    } 

    // 현재 위치 가져오기
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
  }

  // 위도, 경도를 주소로 변환 (역지오코딩)
  Future<String?> getAddressFromLatLng(double lat, double lon) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon, localeIdentifier: 'ko_KR');
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        // 행정구역(subLocality) 또는 도시명(locality) 반환
        return place.subLocality ?? place.locality ?? place.name;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
