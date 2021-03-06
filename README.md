# eduPDFLib

- eduPDFPlayer
    - 문서 파일을 열람하는 뷰어 입니다.
    - 지원하는 문서 형식은 PDF(eduPDF), ZIP(이미지)을 지원 합니다.

- eduPDFWriter
    - 문서 파일을 가공하는 유틸리티 입니다.
    - 지원하는 문서 형식은 PDF를 지원 합니다.

- License
    - eduPDF 확장 기능은 이 라이브러리 버전에 포함한 기능이지만, 상용으로 사용을 할 경우 별도의 라이센스 협의를 해야 합니다.

- Compatibility
    - eduPDFPlayer는 iOS 8.0 이상에서 지원합니다.
    - iOS 7.0에서는 eduPDFPlayerS가 지원합니다.
    - OSX 10.6 이상에서는 eduPDFOSX가 지원합니다.

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
    - 'MapFonts.bundle'을 프로젝트로 드레그하여 추가합니다.(수동)

- Project settings(iOS 7.0, Cocoapods)
    - 프로젝트 'Podfile' 파일을 만들고 아래와같은 내용을 넣습니다.
target "Project Target" do
    pod 'eduPDFLib'
end
    - 'pod install'을 실행 합니다.

- Project settings(OSX 10.6 이상)
    - Build Settings에 Other Link Flags항목에 '-framework eduPDFOSX -ObjC'을 추가 합니다.
    - Build Settings에 Framework Search Paths항목에 '../eduPDFOSXLib/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)'을 추가합니다.
    - 'MapFonts.bundle'을 프로젝트로 드레그하여 추가합니다.

- Opensource Library
    - freeType : Version 2.4.7
    - JPEG : Version 90.9.0
    - Open JPEG : Version 1.4.0
    - TIFF : Version 6.0

- Library usage
    - "[압축해제폴더]/eduPDFPlayerPTest/Samples"에 라이브러리 이용한 샘플 소스들이 있습니다.
    - 샘플 소스 설명
        - Annotation
            - 주석 및 텍스트 선택시 컨텍스트 메뉴 구현 방법 설명 
            - 주석 입력 및 추가, 삭제 액션시 콜백 함수 사용 설명
            - 주석 추가 및 삭제 방법 설명
            - 주석 XFDF 가져오기/내보내기 방법 설명(협업)
            - 주석 목록 가져오기 방법 설명
            - 주석에 사용자 속성 추가 방법 설명
            - 모든 마크업 주석 삭제하기 방법 설명
        - Audio
            - 자동 재생 페이지 동기화 방법 설명(페이지 관련 콜백 함수를 통해 동기화하여 구현)
            - 오디오 재생 상태 콜백 함수 사용 설명
            - 오디오 목록 가져오기 방법 설명
        - Coordination
            - 스크롤 및 확대/축소 콜백 사용 설명
            - API를 통한 스크롤 및 확대/축소 방법 설명
            - 협업등을 목적으로 하는 좌표간 변환 방법 설명(협업)
                - 문서(Origin), 내부 페이지 뷰어(InnerView), 화면(Display), 절대(Absolute) 좌표로 각각 변환
        - Open
            - 로컬 경로 열람
            - 스트림 열람
                - DRM문서의 경우 스트림을 통해 열람할 수 있지만, 열람 완료까지 문서 용량에 비례하여 선형적으로 증가하는 로딩 시간이 걸립니다.
            - HTTP 원격 열람
                - 서버 상태에 따라 다운로드후 열람하거나 바로 스트리밍 열람을 할 수 있습니다.
                - 샘플 코드에 있는 서버는 스트리밍을 합니다.
            - EDDataProvider를 통한 열람(DRM 열람시 필요)
                - DRM문서의 경우 랜덤 액세스를 하기 때문에 로딩 시간이 항상 일정합니다.
        - Text
            - 텍스트 선택 관련 색상 설정 방법 설명
            - 텍스트 선택하여 컨텍스트 메뉴 구현 방법 설명
            - 텍스트 검색 방법 설명
            - TTS 구현 방법 설명
        - Thumbnails
            - 페이지 변경후 콜백 사용 방법 설명
            - 디바이스 회전시 처리 방법 설명
            - 페이지 섬네일 가져와서 활용하는 방법 설명
            - 목차 컨트롤 구현 방법 설명
            - 책갈피 구현 방법 설명
            - 페이지 이동 방법 설명
        - ViewMode
            - 흑백으로 보기 전환 설명
                - 음영 강도 설정 설명
            - 페이지 플립 효과 전환 설명
            - 양면 보기 전환 설명
        - Writer
            - 빈 문서 만들기 설명
            - 페이지에 이미지 삽입하여 표시하기 설명
            - 빈 페이지 추가하기 설명
            - 페이지 복제하여 추가하기 설명
            - 페이지 삭제하기 설명
            - 문서 인쇄하기 설명

- Feature
    - PDF 표준 기능
        - Page View
            - Single(1) Page
            - Double-Side(2) Pages
                - Front Blank(1) Page
            - Multiple(N) Pages
                - Front Blank(N-1) Page
            - Page Move
                - Scroll
                    - Continus
                    - Paging
                    - Vertical
                    - Horizontal
                - Flip(Single And Double-Side Page Only)
            - Page Read Direction
                - Left To Right
                - Right To Left
            - Gray Color Scale
        - Page Navigation
            - GoTo
            - Next
            - Prev
            - Link PageNo
            - Link PageLabel
        - Open
            - Local File
            - Stream(NSInputStream)
            - Random Access Provider(EDDataProvider)
            - Remote Open(HTTP)
                - Fast Open(Streaming or Byte Serving)
                - Download
            - Standard Encryption
            - Unidocs DRM
        - Embed Document Open
            - View
                - Embeding View
                - Floating Popup View
                - Full Screen View
            - Controll Bar
                - Video
                - Audio
            - Format
                - PDF
                - Video
                - Image
                - HTML
                - Audio
        - Link And Attactment
            - Document Attactment
                - Open by the Other App
            - URL
                - Open by the Safari App
            - Page
                - GoTo
            - Label
                - GoTo
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
                - Export
                    - Pages
                    - Types(Markup Types)
                    - Target Annotation Only(To use Collaboation)
                    - Kinds(Form or Makup)
                - Import
            - Event Trigger
                - Touch Enter
                - Page Visible
                - Page Invisible
                - Object Visible
                - Object Invisible
            - Push Effect
                - Outline
                - Pushed
                - Invert
            - User Properties
                - Add Any
                - Callback, Access API
                - Import/Export
                - Save
        - Bookmark
            - Add
            - Remove
            - Modify
        - Outlines
            - Depth
            - Flat
        - Text
            - Text Search
            - Text Selection
            - Text Paragraph(for TTS)
            - Magnifier(for Selection)
        - Writer
            - Create Blank PDF
            - Append Image in the Pages
            - Insert Blank Pages
            - Dublicate Pages
            - Remove Pages
        - Print
            - Print Policy
            - Page Rendering API

    - eduPDF 확장 기능
        - Knowledge Tap
            - One Unit Tap
            - Group Unit Tap
                - Mutually Exclusive
                - InUnison
                - Open All
                - Close All
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
            - Poster Switching
            - Reapet Count
            - Event Trigger
                - Touch Enter/Exit Play/Stop
                - Page Invisible Reset
        - Sticker
            - Animation
            - Drag And Drop Box
            - Play Once
            - Reset
        - Function Button
            - Document Close
            - Knowledge Tap Open All(in the current page).
            - Knowledge Tap Close All(in the current page).
            - Quiz Open All(in the current page).
            - Quiz Close All(in the current page).
            - API
                - All(Tap, Sticker, Quiz, Media) Close(in the current page).
                - All(Tap, Sticker, Quiz) Open(in the current page).

    - Collaboration 기능(for Remote Communication)
        - Annotation Synchronize API
            - XFDF Import/Export
        - Coordinate Transform
            - Document Coordinate
            - Page View Coordinate
            - Display Coordinate(Device Resolution)
            - Absolute Coordinate(Width, Height, Scale Value is 1.0 for default state)
        - View Controll API
            - ZoomTo
            - ScrollTo
            - Add/Remove Page
            - Add Picture
        - Annotation API
            - Callback
                - WillRemove
                - WillRemoveStroke
                - Removed
                - Added
                - Modified
                - Start
                - Moving
                - Sizing
                - Rotating(예정)
                - Stroking
                - Stroked

- 1.0.0 Version Release Notes
    - 추가 사항
        - OSX에서 마우스 입력을 지원합니다.
        - OSX에서 터치(스크롤, 확대) 입력을 지원합니다.
        - 텍스트/주석 선택시 돋보기 기능을 추가하였습니다.
        - 주석 대리 처리(사용자 이미지, 주석 크기) API를 추가하였습니다.
        - 오디오/비디오 컨트롤바를 추가하였습니다.
        - 미디어 구간 재생 및 컨트롤바 표시 기능을 추가하였습니다.
        - 문서뷰에서 스크롤, 확대 축소 제어, 좌표 변환 API를 추가하였습니다.
        - 스크롤, 확대/축소 완료, 문서 닫기 전 콜백 API를 추가하였습니다.
        - 링크, 일반(서식) 버튼 눌림 효과를 추가하였습니다.
        - 기능(문서 닫기, 문제 풀기, 정답 보기 등등) 버튼 기능을 추가하였습니다.
        - 인쇄를 위한 API를 추가하였습니다.
        - 폴리곤 정각형 입력 옵션을 추가하였습니다.
        - 주석 협업을 위한 Callback API를 추가하였습니다. 
    - 개선 사항
        - 페이지 이동, 주석 랜더링 성능을 개선하였습니다.
        - 플립모드에서 페이지 랜더링을 개선하였습니다.
        - 스크롤 전체 영역 계산을 실시간으로 정확하게 갱신하도록 개선하였습니다.
        - 흑백모드를 내장 문서까지 확대 적용하게 개선하였습니다.
        - XPDF 모드로 랜더링시 성능 및 안전성을 개선하였습니다.
    - 오류 수정
        - Text(Sticky-Note) 주석 위치 갱신시 뷰 크기 오류를 수정하였습니다.
        - 주석 사용자 추가 모드에서 동일한 식별자로 들어가는 오류를 수정하였습니다.
        - 페이지 로딩시 스레드 동기화로 인한 무한 대기 오류를 수정하였습니다.
        - 페이지 이동후 페이지 정렬 오류를 수정하였습니다.
        - 플립모드에서 양면보기시 페이지 위치 정렬 오류를 수정하였습니다.
        - 플립모드에서 회전 및 리로드시 간헐적인 충돌 오류를 수정하였습니다. 
        - 페이지 리로드, 이동시 멈춤 현상을 수정하였습니다.
        - 페이지 리로드, 이동시 액션 트리거 동작 오류를 수정하였습니다.
        - XFDF 가져오기/내보내기시 type 속성값에 대문자로 인한 오류를 수정하였습니다.
        - XFDF 가져오기시 동일한 주석이 이미 있는 경우 화면갱신이 안되는 오류를 수정하였습니다.
        - XFDF에서 FreeText 색상 설정 오류를 수정하였습니다.
        
- 0.9.9 Version Release Notes
    - 추가 사항
        - 사용자 주석 속성 설정 기능을 추가하였습니다.
        - OSX를 지원합니다.
        - 빈문서 만들기 기능을 추가하였습니다.
        - 터치 엔터 이벤트 트리거로 애니메이션, 강조 표시 기능을 추가하였습니다.
        - 폴리곤 주석 기능을 추가하였습니다.
        - 페이지에 이미지 넣기 기능을 추가하였습니다.
        - 빈 페이지 넣기 기능을 추가하였습니다.
        - 페이지를 복제하여 넣기 기능을 추가하였습니다.
        - 페이지 삭제하기 기능을 추가하였습니다.
    - 개선 사항
        - 확대시 주석 객체 선택 정밀도를 개선하였습니다.
        - 페이지 리로드시 스레드 안정성을 개선하였습니다.
    - 오류 수정
        - 드랍하여 목표 위치에 피팅한 스티커를 다른 페이지 이동후 돌아와서 다시 표시할 때 오류를 수정하였습니다.
        - 스티커 드레그 앤 드랍시 목표 영역 피팅 표시 오류를 수정하였습니다.
        - 스티커 애니메이션 표시 오류를 수정하였습니다.
        - 닫기 버튼 충돌 오류를 수정하였습니다.
        - GIF 애니메이션 반복횟수, 재생 재개 오류를 수정하였습니다.

- 0.9.8 Version Release Notes
    - 추가 사항
        - 날리지탭 그룹 전체 보이기 숨기기 기능을 추가하였습니다.
        - 포스터 스위칭 기능을 추가하였습니다.
        - 일반 오디오도 자막 표시 기능을 추가하였습니다.
        - 미디어 반복 재생 기능을 추가하였습니다.
        - 페이지 흑백으로 보기 기능을 추가하였습니다.
        - 페이지 넘김 효과를 추가하였습니다.
        - 텍스트 선택 여부 설정 기능을 추가하였습니다.
        - 직접 터치 이벤트를 페이지뷰로 보낼 수 있게 API를 추가하였습니다.
    - 오류 수정
        - 섬네일을 가져올때 문서 열람과 동기화가 안되어 충돌하는 오류를 수정하였습니다.
        - 주석 재생 여부시 스택 오버 플로우 오류를 수정하였습니다.
        - 오디오 페이드인/아웃 효과 오류를 수정하였습니다.
        - 주석 영역 동기화를 하지 않은 경우 이미지 표시 오류를 수정하였습니다.

- 0.9.7 Version Release Notes
    - 추가 사항
        - 마크업 주석 만들기에 필요한 종류별 매개변수 생성 API를 추가하였습니다.
        - 주석/텍스트 선택 및 링크 강조 색상 설정 API를 추가하였습니다.
        - 주석 선택하기 API를 추가 하였습니다.
    - 개선 사항
        - 텍스트 입력 인터랙션을 개선 하였습니다.
        - 스티커 탭, 드레그앤드랍 인터랙션을 개선하였습니다.
        - 마크업 주석 인터랙션을 개선 하였습니다.
        - 주석 속성 변경 데이터 처리 및 표시 갱신을 개선하였습니다.
        - 주석 이미지 해상도, 정밀도, 메모리 사용량을 개선하였습니다.
        - 미디어 팝업을 개선 하였습니다.
    - 오류 수정
        - 글상자(FreeText) 텍스트 표시 오류를 수정 하였습니다.
        - 비디오 플롯팅 팝업후 전체보기 전환후 재생 완료시 오류를 수정하였습니다.
        - 마크업 날리지탭 표시 오류를 수정 하였습니다. 
        - 주석 표시 오류를 수정 하였습니다.
        - 폰트가 내장 안된 컨텐츠 텍스트 표시 및 가져오기 오류를 수정하였습니다. 
        - 퀴즈 채점 표시 오류를 수정 하였습니다.
        - 퀴즈 선긋기 표시 오류를 수정 하였습니다.
        - 퀴즈 채점 해제시 충돌 문제를 수정 하였습니다.
        - 페이지 넘김시 미디어 재생 중지 오류를 수정 하였습니다.
        - ZIP 이미지 문서 열람시 충돌 오류를 수정 하였습니다.

- 0.9.6 Version Release Notes
    - 추가 사항
        - Highlight, Underline, StrikeOut, FreeText, Rectangle, Circle, Square, Stamp 주석 기능을 추가하였습니다.
        - Stiker Play Once, Reset기능을 추가하였습니다.
        - 마크업 주석 속성 수정 기능을 추가 하였습니다.
        - 마크업 주석 지우개 기능을 추가 하였습니다.
        - 주석 가져오기/내보내기 기능(XFDF)을 추가하였습니다.
        - 텍스트 선택 기능을 추가 하였습니다.
        - 페이지 단락(문장들) 가져오기 기능을 추가하였습니다.
        - 문서 스트림 열람기능을 추가 하였습니다.
    - 개선 사항
        - 문서 닫기 안전성을 개선 하였습니다.
        - 문서 팝업 표시방법을 개선 하였습니다.
        - Public API Renewal
    - 오류 수정
        - Stiker 연속 애니메이션시 재생시 재생을 중복 실행하지 않게 수정하였습니다.
        - Stiker 무한 반복 애니메이션인 경우 애니메이션 여부 예외처리를 추가하였습니다.

- 0.9.5 Version Release Notes
    - 추가 사항
        - Scroll Lock기능을 추가 하였습니다.
        - Fading Effect, BGM, Media Play Once기능을 추가하였습니다.
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



