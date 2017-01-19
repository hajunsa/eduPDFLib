# eduPDFLib

- eduPDFPlayer
    - 문서 파일을 열람하는 뷰어 입니다.
    - 지원하는 문서 형식은 PDF(eduPDF), ZIP(이미지)을 지원 합니다.

- License
    - eduPDF 확장 기능은 이 라이브러리 버전에 포함한 기능이지만, 상용으로 사용을 할 경우 별도의 라이센스 협의를 해야 합니다.

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
    - 'MapFonts.bundle'을 프로젝트로 드레그하여 추가합니다.(수동)

- Project settings(iOS 7.0, Cocoapods)
    - 프로젝트 'Podfile' 파일을 만들고 아래와같은 내용을 넣습니다.
target "Project Target" do
    pod 'eduPDFLib'
end
    - 'pod install'을 실행 합니다.

- Opensource Library
    - freeType : Version 2.4.7
    - JPEG : Version 90.9.0
    - Open JPEG : Version 1.4.0
    - TIFF : Version 6.0

- Library usage
    - 샘플 예제를 제공합니다.

- Feature
    - PDF 표준 기능
        - 단면, 여러면 보기. 다양한 페이지 정렬. 읽기 방향. 스크롤/페이징 보기
        - 페이지 네비게이션.
        - 다양한 형태 열람.
            - 로컬 파일
            - Stream(NSInputStream)
            - 랜덤 액세스 제공자(EDDataProvider)
            - 원격 열람(HTTP)
                - Fast Open(Streaming or Byte Serving)
                - Download
            - Standard Encryption
            - Unidocs DRM
        - 문서 내장, 팝업, 전체화면 지원
            - PDF
            - Video
            - Image
            - HTML
            - Audio
        - 링크 및 첨부
            - 문서
                - hwp
                - office
            - URL
        - Annotation
            - Form Widget Annotation
                - Text
                - Check
                - Radio
                - Combo
                - List
            - Markup Annotation
                - Sticky Note
                - Ink
                - Line
                - Highlight
                - Underline
                - StrikeOut
                - FreeText
                - Rectangle
                - Circle
                - Square
                - Stamp
                - Eraser(for Remove)
            - XFDF
        - Bookmark
        - Outlines
        - Text
            - Text Search
            - Text Selection
            - Text Paragraph(for TTS)
    - eduPDF 확장 기능
        - Knowledge Tap
        - Quiz
            - 그룹 문제 풀기(여러 Quiz Item이 연결된 형태)
            - 단답형(Radio, Combo, Text)
            - 다답형(Check, Text)
            - 선긋기
            - 다른 부분 찾기
                - 정답 채점
                - 정답 채점 초기화
        - Media
            - Play Once
            - Scroll Lock
            - Audio
                - Subtitles Audio
                    - 객체별 자막 색상 설정
                    - 여러 페이지 지원(하나의 음원으로)
                - BGM
                - Audio Auto Play
                - Fading Effect
            - Frame Animation
                - GIF
                - Zipped-Image
        - Sticker
            - Animation
            - Drag And Drop Box
            - Play Once
            - Reset

- 0.9.7 Version Release Notes
    - 추가 사항
        - 마크업 주석 만들기에 필요한 종류별 매개변수 생성 API를 추가 하였습니다.
        - 주석/텍스트 선택 및 링크 강조 색상 설정 API를 추가 하였습니다.
        - 주석 선택하기 API를 추가 하였습니다.
    - 개선 사항
        - 텍스트 입력 인터랙션을 개선 하였습니다.
        - 스티커 탭, 드레그앤드랍 인터랙션을 개선 하였습니다.
        - 마크업 주석 인터랙션을 개선 하였습니다.
        - 주석 속성 변경 데이터 처리 및 표시 갱신을 개선 하였습니다.
        - 주석 이미지 해상도, 정밀도, 메모리 사용량을 개선 하였습니다.
        - 미디어 팝업을 개선 하였습니다.
    - 오류 수정
        - 글상자(FreeText) 텍스트 표시 오류를 수정 하였습니다.
        - 비디오 플롯팅 팝업후 전체보기 전환후 재생 완료시 오류를 수정 하였습니다.
        - 마크업 날리지탭 표시 오류를 수정 하였습니다. 
        - 주석 표시 오류를 수정 하였습니다.
        - 폰트가 내장 안된 컨텐츠 텍스트 표시 및 가져오기 오류를 수정 하였습니다. 
        - 퀴즈 채점 표시 오류를 수정 하였습니다.
        - 퀴즈 선긋기 표시 오류를 수정 하였습니다.
        - 퀴즈 채점 해제시 충돌 문제를 수정 하였습니다.
        - 페이지 넘김시 미디어 재생 중지 오류를 수정 하였습니다.
        - ZIP 이미지 문서 열람시 충돌 오류를 수정 하였습니다.
- 0.9.6 Version Release Notes
    - 추가 사항
        - Highlight, Underline, StrikeOut, FreeText, Rectangle, Circle, Square, Stamp 주석 기능을 추가 하였습니다.
        - Stiker Play Once, Reset기능을 추가 하였습니다.
        - 마크업 주석 속성 수정 기능을 추가 하였습니다.
        - 마크업 주석 지우개 기능을 추가 하였습니다.
        - 주석 가져오기/내보내기 기능(XFDF)을 추가 하였습니다.
        - 텍스트 선택 기능을 추가 하였습니다.
        - 페이지 단락(문장들) 가져오기 기능을 추가 하였습니다.
        - 문서 스트림 열람기능을 추가 하였습니다.
    - 개선 사항
        - 문서 닫기 안전성을 개선 하였습니다.
        - 문서 팝업 표시방법을 개선 하였습니다.
        - Public API Renewal
    - 오류 수정
        - Stiker 연속 애니메이션시 재생시 재생을 중복 실행하지 않게 수정 하였습니다.
        - Stiker 무한 반복 애니메이션인 경우 애니메이션 여부 예외처리를 추가 하였습니다.

- 0.9.5 Version Release Notes
    - 추가 사항
        - Scroll Lock기능을 추가 하였습니다.
        - Fading Effect, BGM, Media Play Once기능을 추가 하였습니다.
        - 그룹 문제 풀기기능을 추가 하였습니다.
        - 목차, 텍스트 검색, 책갈피 기능을 추가 하였습니다.
        - Sticky Note, Ink, Line 주석 기능을 추가 하였습니다.
        - 첨부 문서(hwp, office) 열람 연결 기능을 추가하였습니다.
        - HTML 문서 팝업 기능을 추가 하였습니다.
        - Unidocs DRM 기능을 추가 하였습니다.
        - PDF 문서 내부 설정 적용 기능을 추가 하였습니다.
        - 여러 페이지에 걸친 자막 오디오 기능을 추가 하였습니다.
        - 자막 오디오에서 자막별 색상 적용을 추가 하였습니다.
    - 개선 사항
        - 주석 표시 기능을 개선 하였습니다.
        - 내장 문서 팝업 기능을 개선 하였습니다.
        - 페이지 리셋 기능을 개선 하였습니다.
        - 텍스트 필드 입력 기능을 개선 하였습니다.
        - 문서 로딩 표시 기능을 개선 하였습니다.
    - 오류 수정
        - Knowledge Tap 동작 오류를 수정하였습니다.
        - 주석 표시 순서 오류를 수정하였습니다.
        - GIF 반복 횟수 오류를 수정하였습니다.
        - 페이지 프레임 정렬 오류를 수정하였습니다.

- 0.9.4 Version Release Notes
    - 추가 사항
        - Cocoapods 배포를 시작합니다.
        - 스크롤뷰 콜백 API를 추가 하였습니다.
        - Subtitles Audio
            - 객체 전체 재생 기능을 추가 하였습니다.
    - 개선 사항
        - 2면 보기 이상에서 스크롤시 스레드 안정성을 개선하였습니다.
        - 주석 객체 터치 정확도를 개선 하였습니다.
    - 오류 수정
        - 멀티미디어중 리치미디어 재생 오류를 수정하였습니다.
        - 내장 문서 팝업 이미지 문서 열기 오류를 수정하였습니다.
        - Knowledge Tap 그룹 탭 오류를 수정하였습니다.

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



