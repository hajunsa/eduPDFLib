# eduPDFLib
- Description
    - 문서 파일을 열람하는 뷰어 입니다.
    - 지원하는 문서 형식은 PDF(eduPDF), ZIP(이미지)을 지원 합니다.

- Compatibility
    - eduPDFPlayer는 iOS 8.0 이상에서 지원합니다.
    - iOS 7.0에서는 eduPDFPlayerS가 지원합니다.

- Info.plist settings
    - 'licenseCode'항목을 'String'타입으로 추가하고, 발급 받은 라이센스 코드를 입력합니다.
발급 받은 코드와 번들 아이디가 일치하지 않으면 문서 열람이 안됩니다.

- Project settings(iOS 8.0 이상)
    - General에 Embedded Binaries항목에 eduPDFPlayer.framework을 추가 합니다.
    - 빌드 환경에 맞는 eduPDFPlayer.framework(Debug-iphonesimulator, Release-iphoneos 제공)을 추가 해야 합니다.

- Project settings(iOS 7.0)
    - Build Settings에 Other Link Flags항목에 '-framework eduPDFPlayerS -ObjC'을 추가 합니다.
    - Build Settings에 Framework Search Paths항목에 '../eduPDFPlayerSLib/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)'을 추가합니다.
    - Build Settings에 Enable Bitcode 항목을 NO로 설정합니다.
    - Build Phases에 Link Binary With Libraries 항목에서 'libc++.tbd', 'libxml2.tbd', 'libz.tbd'을 추가합니다.
    - eduPDFPlayerS.framework폴더안에 'CMap', 'fonts'를 프로젝트로 드레그하여 Create folder references로 추가합니다.

- Project settings(iOS 7.0, Cocoapods)
    - 프로젝트 'Podfile' 파일을 만들고 아래와같은 내용을 넣습니다.
target "Project Target" do
pod 'eduPDFLib'
end
    - 'pod install'을 실행 합니다.
    - eduPDFPlayerS.framework폴더안에 'CMap', 'fonts'를 프로젝트로 드레그하여 Create folder references로 추가합니다.(수동)

- Opensource Library
    - freeType : Version 2.4.7
    - JPEG : Version 90.9.0
    - Open JPEG : Version 1.4.0
    - TIFF : Version 6.0

- Library usage
    - 샘플 예제를 제공합니다.

- Feature
    - PDF 열람
        - 단면, 여러면 보기. 다양한 페이지 정렬. 읽기 방향. 스크롤/페이징 보기
        - 페이지 네비게이션.
        - 다양한 형태 열람.
            - 로컬 파일
            - 랜덤 액세스 제공자(EDDataProvider)
            - 원격 빠른 열람(HTTP)
        - 서식 입력 기능.(텍스트, 체크, 라디오, 콤보, 리스트)
        - 내장 문서 팝업
        - PDF
        - 동영상
        - 이미지
    - eduPDF 열람
        - Knowledge Tap
        - Quiz
            - 단답형(Radio, Combo, Text)
            - 다답형(Check, Text)
            - 선긋기
            - 다른 부분 찾기
            - 정답 채점
            - 정답 채점 초기화
        - Subtitles Audio
        - Frame Animation
        - GIF
        - Zipped-Image
        - Sticker
            - Animation
            - Drag And Drop Box

- 0.9.3 Version Release Notes
- 개선 사항
- 뷰어 확대/축소시 페이지 정렬 기능을 제거하였습니다.
- 주석 표시 해상도 및 위치 정확도를 개선하였습니다.
- 주석 가져오기 속도를 개선하였습니다.
- Sticker
- 스티커 드레그시 정확도를 개선하였습니다.
- 스티커 드랍시 장착 정확도를 개선하였습니다.
- 오류 수정
- 양면 보기 이상에서 열람 문제를 수정하였습니다.
- 특정 페이지 바로가기시 페이지 표시 오류를 수정하였습니다.
- 서식
- 버튼 텍스트 표시 오류를 수정하였습니다.
- 내장한 멀티 미디어
- 내장 문서 표시 메모리 할당 문제, 충돌 및 오류 수정하였습니다.
- 비디오 주석 충돌 및 표시 오류 수정하였습니다.
- Frame Animation
- 프레임 애니메이션이 재생 버튼에서 나타나는 오류 수정하였습니다.
- Subtitles Audio
- 자막 오디오 충돌 및 표시 오류 수정하였습니다.
- Quiz
- 채점 버튼 충돌 오류 수정하였습니다.

- 0.9.2 Version Release Notes
- iOS 7.0 지원

- 0.9.1 Version Release Notes
- Quiz
- 다른 부분 찾기 기능을 지원합니다.
- 사용자 Footer를 추가하는 기능을 지원합니다.
- 사용자 DRM문서 열람 기능을 지원합니다.
- 오류 수정
- GIF 애니메이션 무한 반복 오류를 수정하였습니다.
- Paging View에서 가로 보기시 표시 오류를 수정하였습니다.
- Knowledge Tap
- 탭시 그룹 동작 오류를 수정하였습니다.

- 0.9.0 Version Release Notes
- PDF 문서 열람 기능을 지원 합니다.
- 이미지 ZIP 파일 열람 기능 지원 합니다.
- 링크 기능(페이지, URL)을 지원 합니다.
- 내장한 멀티 미디어(동영상, 오디오)를 재생 합니다.
- 서식(Text, Combo, List, Check, Radio) 입력을 지원 합니다.
- 내장 문서 팝업 기능을 지원 합니다.
- PDF
- 동영상
- 이미지
- eduPDF 기능을 지원 합니다.
- Knowledge Tap
- Quiz
- 단답형(Radio, Combo, Text)
- 다답형(Check, Text)
- 선긋기
- 다른 부분 찾기
- 정답 채점
- 정답 채점 초기화
- Subtitles Audio
- Frame Animation
- GIF
- Zipped-Image
- Sticker
- Animation
- Drag And Drop Box
- Event Trigger
- Animation Start/Completion Event Trigger
- Page Visible/Invisible Event Trigger
- Touch up Event Trigger
- 여러가지 뷰 설정(Continous/Paging View, Scroll Direction, Read Direction, Display Fitting)을 제공 합니다.
- Random Access Streaming(Fast Open or Byte Serving)을 지원합니다.



