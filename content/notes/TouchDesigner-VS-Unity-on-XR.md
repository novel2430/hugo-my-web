+++
title = 'TounchDesigner vs Unity (XR)'
date = '2025-11-14T17:27:15+08:00'
draft = false 
tags = ['VR', 'AR', 'Unity', 'TouchDesigner' ]
isCJKLanguage = true
+++
## 一、VR 設備大概可以怎麼分類？

先把設備種類講清楚，後面範式才好對齊：

1. **PC-VR（繫線型）**

   * 例：HTC Vive / Vive Pro、Valve Index、舊 Oculus Rift、Windows MR，或 Quest 透過 Link/AirLink 當 PC-VR 用。
   * 頭顯只是顯示器＋追蹤裝置，**主要算力在 Windows PC 上**。
   * 常用 SteamVR / OpenVR / OpenXR 這種 runtime。

2. **Standalone VR（一體機）**

   * 例：Meta Quest 系列、Pico 等。
   * 頭顯內有 SoC，可以直接在裝置上跑 Android app，也可選擇用 Link 把它「變身」成 PC-VR。

3. **空間計算 / MR 類（以 AVP 為代表）**

   * Apple Vision Pro：跑 **visionOS**，重點是「空間 app + 手眼互動」，不走 OpenXR，那整套是 ARKit/RealityKit/PolySpatial 的世界。

## 二、TouchDesigner 在 AVP 上的典型使用範式

TouchDesigner **無法直接在 AVP 上跑，也無法 build 成 visionOS app**，所以目前社群實際在用的路線長這樣：

1. **PC / Mac 上跑 TouchDesigner：**

   * TD 負責做 2D/3D/360 實時視覺，像平常的 generative patch。
   * 用 **NDI Out TOP** 把畫面（常見是 360 equirectangular）當作視訊串流丟到區網

2. **AVP 上跑 Unity/visionOS App：**

   * 例如官方社群資源的 **iXR OSC & NDI（visionOS app）** 或 **iControl OSC & NDI**：

     * App 內建 **NDI receiver**，收 TD 丟來的 360 影片並貼到球體 / quad 上顯示。
     * 同時用 visionOS 的 hand tracking 拿手的 3D 座標與 pinch 狀態，
     * 再透過 **OSC over UDP** 把這些數值丟回 TD

3. **雙向資料流：**

* **TD → AVP：** NDI 影片（＋可能的音訊）。
* **AVP → TD：** 手部座標 / 手勢、頭部信息等，用 OSC、UDP/TCP 等格式。

所以你看到的那種作品，本質其實是：

> **「PC 上的 TD 是唯一渲染核心，AVP 只是『顯示器＋手部感測器』，兩邊靠 NDI + OSC 遠端互動。」**


## 三、在 AVP 上：TD vs Unity 的優劣（總表）

### 1. TouchDesigner + AVP 橋接：優點

**（1）對「展覽／裝置」工作流超友善**

* TD 原生支援 HTC Vive / OpenVR / Oculus VR，還有各種感測與控制（MIDI、OSC、DMX、Kinect/深度相機…），就是為現場多媒體裝置設計的
* 一個 TD patch 可以同時：

  * 驅動投影 / LED wall
  * 控燈光 / 音響
  * 並透過 NDI 餵給 AVP 看
    → AVP 只是**整套空間作品中的其中一個端點**，這是 Unity 單機 App 很難取代的。

**（2）Generative / 視覺實驗迭代速度快**

* 你在 TD 裡改 node、調 shader、加 feedback，PC 端即時看到結果，AVP 那邊也因為 NDI 立即更新。
* 不需要每次調視覺都重 build 一個 visionOS App，對 VJ／實驗藝術家來說 workflow 很爽。

**（3）一份 TD 內容可以餵很多前端**

* 同一個 TD patch 可以同時：

  * NDI → AVP
  * NDI → Quest NDI viewer
  * HDMI/SDI → 傳統螢幕、投影
  * DMX/ArtNet → 燈具
* 所有人看到的是同一個「演算世界」，只是不同 P.O.V.

### 2. TouchDesigner + AVP 橋接：缺點（相對於 Unity 原生 visionOS）

**（1）系統複雜度與維護成本高**

* 結構是「TD + 網路 + AVP App」，多了 NDI 編碼/解碼、OSC 封包、IP/port、同步等問題。
* Debug 要同時看 PC log 和 AVP log，比「純 Unity visionOS App」多至少一倍複雜度。

**（2）延遲一定會高於原生**

* OpenVR/Oculus CHOP/TOP 這種 direct PC-VR 已經追求低 latency，
* 再加一層 NDI（壓縮→送網路→解壓）＋ OSC delay，頭動→畫面動的黏著感一定不如 Unity 原生 PolySpatial pipeline

**（3）無法完全吃到 visionOS / PolySpatial 的空間能力**

* Unity + PolySpatial 是直接在 visionOS 上建 3D scene，有：

  * 空間錨點、真實環境遮擋、空間 UI、room mesh、native 手眼互動等
  
* TD → AVP 的 NDI 模式，畫面本質上就是一張 360 影像或平面貼圖，

  * 頂多把它貼在一個 sphere / quad 上，你能動的是「球 / 平面在空間裡」而不是 TD 裡的真正 3D 幾何。
  * 想利用空間 occlusion / 3D UI 還是要在 AVP 端補一套 Unity/RealityKit 場景。

**（4）成品不容易走「使用者自己下載就能跑」路線**

* 不論怎麼包裝，作品永遠需要一台 PC 開著 TouchDesigner。
* 對展覽、實驗室沒問題，但如果要的是「App Store 上讓一般人下載的 AVP app」，那 Unity/RealityKit 原生 visionOS 會是唯一正規選項

## 四、TouchDesigner 在其他 VR 設備上的使用範式

### 1. 在 PC-VR 頭顯上（Vive / Index / Rift / Quest+Link 等）

這一類其實是 **TouchDesigner 最舒服的 VR 場景**：

* TD 官方有完整的 **HTC Vive / OpenVR / Oculus VR 支援**：

  * **OpenVR TOP**：把左眼/右眼圖像輸出到 SteamVR 頭顯。
  * **OpenVR CHOP**：讀取 HMD 和 controller 的位置、方向、按鍵、動作等。
  * **Oculus Rift TOP / CHOP / SOP**：對 Meta 頭顯（Rift/Link 模式 Quest）做類似操作
* Derivative 還提供一個「TouchDesigner VR Development Environment for HTC Vive」範例，裡面有 teleport、selection、locomotion 等基本交互

**範式關鍵點：**

> **PC 上 TD 直連 SteamVR / Oculus runtime：
> TD 同時做「渲染 + 接收頭顯/控制器輸入」，
> 根本不需要 Unity、也不需要 NDI/OSC 橋接。**

這跟 AVP 那套「一定要中間架一個 App + 網路」的 workaround 差很多。

### 2. 在 Standalone VR 上（Meta Quest / Pico 等）

這類其實有兩種典型用法：

**（A）當 PC-VR 用：Link / AirLink / SteamVR Streaming**

* 用 Link 線或 AirLink 把 Quest 接到 PC，讓它被當成 Rift 類設備。
* 此時你在 PC 上跑 TD + Oculus/OpenVR TOP/CHOP，跟用 Rift Pro 幾乎同一套流程

**（B）走「跟 AVP 類似的 NDI/OSC 橋接」**

* 在 Quest 裡安裝一個 NDI viewer（或自己用 Unity 寫一個），接收 TD 的 NDI 畫面並貼到 360/quad
* Quest 端程式把控制器／手勢資訊變成 OSC/TCP，回傳給 PC 上的 TD。
* 範式跟 AVP 幾乎一樣，只是這邊是 Android/Unity app，而 AVP 那邊是 visionOS/Unity app。

**總結**：

* 有「PC 在場」→ 優先考慮當 PC-VR 用，TD 直接驅動頭顯。
* 想要無線／多設備混接 → 才用 NDI/OSC 這類橋接方法。

## 五、總收斂：什麼時候用哪一種？

* **要做「頭顯內原生 app」：**

  * 例如 AVP 上的 Verseflow、Quest 上的遊戲、可上架商店、完全靠頭顯運算
    → **用 Unity / RealityKit 做主體**，TD 頂多當內容生成器（離線素材或少量在線 streaming）。

* **要做「有空間裝置的展覽／演出」：**

  * 同時有投影、LED、實體燈光、感測器，頭顯只是其中一個端點
    → **TD 當場域的大腦**，PC-VR 頭顯可以直接由 TD 駕馭；
    → AVP / Standalone VR 則透過 **NDI + OSC** 當「viewer + sensor」。
    
## 六、參考網站

- [OpenVR | Derivative - TouchDesigner](https://derivative.ca/UserGuide/OpenVR?utm_source=chatgpt.com)
- [visionOS Platform Overview | PolySpatial visionOS | 1.0.3](https://docs.unity3d.com/Packages/com.unity.polyspatial.visionos%401.0/manual/visionOSPlatformOverview.html?utm_source=chatgpt.com)
- [VR Support | Derivative - TouchDesigner](https://derivative.ca/feature/vr-support/12?utm_source=chatgpt.com)
- [apple vision pro | Derivative - TouchDesigner](https://derivative.ca/tags/apple-vision-pro?utm_source=chatgpt.com)
- [OpenVR TOP | Derivative - TouchDesigner](https://derivative.ca/UserGuide/OpenVR_TOP?utm_source=chatgpt.com)
- [OpenVR CHOP - TouchDesigner Documentation](https://docs.derivative.ca/OpenVR_CHOP?utm_source=chatgpt.com)
- [Oculus Rift - Derivative](https://docs.derivative.ca/Oculus_Rift?utm_source=chatgpt.com)
- [TOUCHDESIGNER VR DEVELOPMENT ENVIRONMENT](https://docs.derivative.ca/images/e/e4/TouchDesigner_VR_Development_Environment_for_HTC_Vive.pdf?utm_source=chatgpt.com)
- [OpenVR, OpenXR, Vive OpenXR etc. which SDK I should ...](https://www.reddit.com/r/Vive/comments/tffcfy/openvr_openxr_vive_openxr_etc_which_sdk_i_should/?utm_source=chatgpt.com)


