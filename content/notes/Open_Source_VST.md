---
title: 'VST Introduction'
date: 2025-03-12T17:41:00+08:00
draft: false
categories: 
tags: # 自由新增
    - DAW
    - DSP
isCJKLanguage: true # 是否是中文(chinese,japanese,korea) 字數判斷用
comments: true
showToc: true # 顯示目錄
TocOpen: true # 預設打開目錄
hidemeta: false # 是否隱藏meta訊息(ex:發布日期、作者...etc)
disableShare: false # 取消社群分享區塊
showbreadcrumbs: true # 於頂部顯示文章路徑
ShowWordCounts: true
ShowReadingTime: true
ShowLastMod: true
---
# 合成器, 效果器, 混音相关算法与开源实践
## 功能概述
![img](https://github.com/novel2430/MyImage/blob/main/VST_01_01.png?raw=true)  
图1. 三种算法在音乐工程中的示意图
### 合成器 Synthesizer
合成器可以理解成一种特别的**音源**，由创作者调节参数做出独一无二的声音。与虚拟乐器(VSTi)不同的，合成器不是为了模仿已存在的乐器，而是根据创作者自身对乐曲的需求特别产生。早期合成器的声音，多为了渲染**乐曲的氛围**而生。到了电子音乐(EDM)被主流肯定的年代，合成器逐渐成为了歌曲的主角。  
合成器的原理，最简单的理解便是对**波形**的改造，可能将两个波叠加，相减，或是对单一波的形状调整，都能得到不一样的声音。
### 效果器 Audio Effect
效果器主要目的便是对已有声音进行**润色**，其基础概念也是对声音的波形做调整。但与合成器不同的部份，主要有两点：其一，效果器的重点是对**已存音色**做微调，而非从0开始制造出音色，其二，它对音频波的改动是基于固定几种方式的，而这些方式得到的效果便是我们常听到的，混响，延迟等。
### 混音 Mixing & Mastering
**混音 Mixing**  
混音是将所有单独录制的音轨（人声、鼓、吉他、贝斯、合成器等）进行平衡、调整、处理，使它们听起来协调，并最终形成一首完整的歌曲。  
在混音的阶段，也会活用上述**效果器**所带来的功能，但其目标非对单轨音色进行调整，而是着重在多轨音色的和谐。  
混音的目标:
- 平衡音量（确保所有乐器在人耳中都能清楚地听到）
- 处理频率冲突（避免不同乐器的声音遮蔽）
- 调整声像（Panning）（使声音在立体声场中有良好的空间感）
- 控制动态范围（压缩/限制器，避免声音忽大忽小）
- 加入空间感（混响、延迟，让声音听起来自然）

**母带 Mastering**  
母带处理是对 混音好的歌曲 进行最后的调整，确保歌曲在所有播放设备上（耳机、手机、音箱、车载音响）都能有良好的听感，并符合行业标准的音量要求（如 Spotify、Apple Music 等的 LUFS 标准）。  
母带的目标:
- 优化整体音量（提升到行业标准，而不会失真）
- 均衡整个频率范围（让高频清晰、低频扎实）
- 增强立体声宽度（使歌曲听起来更开阔）
- 确保动态范围合适（不会过度压缩，使音乐有起伏）
- 格式转换（导出适合 CD、流媒体、黑胶的版本）

## 合成器相关VST

在数字音乐制作中，**合成器（Synthesizer）** 是一种用于生成电子音色的工具，它可以模拟传统乐器的声音，也可以创造全新的、无法由自然乐器发出的音色。而 **VST（Virtual Studio Technology）** 则是一种插件格式，使得这些合成器可以作为软件运行在 **DAW（数字音频工作站）** 中，广泛应用于电子音乐、电影配乐、游戏音效等领域。

> 知名合成器VST -- **Serum**

![img](https://bvker.com/wp-content/uploads/2019/06/Rocket-Powered-Sound-Designer-Serum-Skin.jpg)

### 合成器的基本原理
合成器的核心功能是 **通过电子方式生成和控制声音**。它主要依靠以下几个核心模块：

#### (1) 振荡器 Oscillator
振荡器是合成器的音源部分，负责产生基本波形，如：
- **正弦波（Sine Wave）**：最纯净的波形，只有基频，听起来类似于简单的哨声。
- **锯齿波（Sawtooth Wave）**：包含所有谐波成分，音色明亮，常用于弦乐合成。
- **方波（Square Wave）**：仅包含奇次谐波，音色接近管风琴或电子乐中的主音。
- **三角波（Triangle Wave）**：主要包含低阶奇次谐波，音色较柔和。

多个振荡器可以相互叠加，或通过调制（如 **FM 合成、AM 合成**）产生更复杂的波形。例如：
- **波叠加合成（Additive Synthesis）**：通过多个简单波形的叠加，构建出复杂音色。数学上可以通过傅立叶级数来描述，即任意周期信号都可以分解为多个正弦波的叠加。
- **减法合成（Subtractive Synthesis）**：先生成丰富的波形，再通过滤波器削减部分频率成分，以获得特定的音色。

#### (2) 滤波器 Filter
滤波器用于调整音色的频谱特性，最常见的类型包括：
- **低通滤波器（LPF, Low-Pass Filter）**：允许低频通过，削减高频，使声音更柔和。
- **高通滤波器（HPF, High-Pass Filter）**：允许高频通过，削减低频，使声音更清亮。
- **带通滤波器（BPF, Band-Pass Filter）**：仅保留一定范围内的频率，适用于特定音效处理。

#### (3) 包络 Envelope
包络控制声音随时间的演变，最常见的是 **ADSR**（Attack-Decay-Sustain-Release）：
- **Attack（起音）**：声音从零到最大音量的时间。
- **Decay（衰减）**：从最大音量下降到持续音量的时间。
- **Sustain（持续）**：声音保持的稳定音量。
- **Release（释放）**：声音从持续音量降至零的时间。

包络决定了声音的动态特性，例如模拟钢琴的短暂击弦或小提琴的渐进拉弓效果。

#### (4) 低频振荡器 LFO, Low-Frequency Oscillator
LFO 作用于其他参数，产生周期性的变化，例如：
- 通过 LFO 控制音高，可以生成 **颤音（Vibrato）** 效果。
- 通过 LFO 控制音量，可以生成 **抖音（Tremolo）** 效果。
- 通过 LFO 控制滤波频率，可以生成 **扫频（Wobble）** 效果，广泛用于 Dubstep 音色设计。

### 合成器VST的主要合成方式
不同的合成器VST采用不同的声音合成方式，常见的包括：

#### 加法合成 Additive Synthesis
基于傅立叶级数的思想，将多个简单波形（如正弦波）叠加，形成复杂音色。例如，**Harmor** 采用这种方式来合成丰富的音色。

#### 减法合成 Subtractive Synthesis
通过滤波器对富含谐波的波形进行频率衰减，以塑造特定音色。**Serum、Sylenth1、Massive** 等主流合成器都采用此方法。

#### 频率调制合成 FM Synthesis
通过一个波形调制另一个波形的频率，以产生复杂的谐波结构。例如，**Yamaha DX7** 硬件合成器及其 VST 版本 **FM8** 采用此方法。

#### 采样合成 Sampling Synthesis
基于预录音色进行变调和处理，例如 **Kontakt** 采样库可以模拟真实乐器。

#### 波表合成 Wavetable Synthesis
基于波形表存储不同的波形，并允许动态切换，例如 **Serum** 提供了丰富的波表编辑功能。

### 合成器与AI技术 - Synplant2 (2023)
Synplant 是由 Sonic Charge 开发的一款软件合成器，不同于传统合成器依赖旋钮和参数调节，Synplant 采用**遗传**概念，允许用户通过种植和**发展种子**来探索和创造声音。  
这种方法提供了一种非线性的音色生成方式，使用户能够在实验过程中逐步发现不同的声音特性。  
在 Synplant 2 版本中，能利用人工智能分析音频样本，并生成匹配的合成音色。相比手动调节合成参数，这一功能可以在更短时间内获得接近目标的音色，同时保留一定的创造空间。此外，Synplant 2 还引入了 **DNA 编辑器**，允许用户深入修改声音的核心属性，包括包络、振荡器类型、滤波器等，以实现更精确的音色塑造。  
[link](https://soniccharge.com/synplant): https://soniccharge.com/synplant
![img](https://cdn.soniccharge.com/rc/adfc42e7/static/images/S2-DNAEditor.png)

### 开源合成器
#### 减法合成器 Subtractive Synthesizers

**特点**：通过产生谐波丰富的波形（如锯齿波、方波等），然后使用滤波器削减特定频率成分，以塑造所需音色。

**案例**：

- [OB-XD](https://github.com/reales/OB-Xd) - Oberheim emulation
	- https://github.com/reales/OB-Xd
	![img](https://i0.wp.com/obxd.wordpress.com/wp-content/uploads/2016/05/blue.png?w=752&h=235&ssl=1)
- [monique-monosynth](https://github.com/surge-synthesizer/monique-monosynth) - Bass & Lead
	- https://github.com/surge-synthesizer/monique-monosynth
	![img](https://cdn.shortpixel.ai/spai/q_lossy+w_750+to_webp+ret_img/www.delamar.de/wp-content/uploads/2021/02/monoplugs_monique.jpg)
- [amsynth](https://github.com/Amsynth/Amsynth)
	- https://github.com/Amsynth/Amsynth
	![img](https://linuxaudio.github.io/libremusicproduction/html/sites/default/files/tools/amsynth.png)

#### 频率调制合成器 FM Synthesizers

**特点**：通过一个振荡器调制另一个振荡器的频率，产生复杂的谐波结构，适合创造金属质感或电钢琴等音色。

**案例**：

- [Dexed](https://github.com/asb2m10/dexed) - yamaha dx7 emulation
	- https://github.com/asb2m10/dexed
	![img](https://images.squarespace-cdn.com/content/v1/54d696e5e4b05ca7b54cff5c/4cada961-5b03-4bc6-ba9c-7f1bd891bbe8/dexed+-+FM+Plugin+Synth.jpg?format=1500w)

#### 波表合成器 Wavetable Synthesizers

**特点**：通过在不同波形之间进行插值，创造动态变化的音色，适用于复杂且富有运动感的声音设计。

**案例**：

- [Surge](https://github.com/surge-synthesizer/surge) - Hybrid synthesizer / MPE compatible
	- https://github.com/surge-synthesizer/surge
	![img](https://surge-synthesizer.github.io/images/manual/Pictures/surge.png)
- [Vital](https://github.com/mtytel/vital) - spectral warping wavetable synth
	- https://github.com/mtytel/vital
	![img](https://cdn.shopify.com/s/files/1/0297/3233/9847/files/vital_synth_plugin_free_download.png?v=1691627327)
- [Helm](https://github.com/mtytel/helm) - 2 oscilator wavetable synthesizer
	- https://github.com/mtytel/helm
	![img](https://splice-res.cloudinary.com/image/upload/f_auto,q_auto,w_auto/t_plugin_detail/v1442865517/production/plugin_descriptions/screenshot/1762026.jpg)
- [Yoshimi](hhttps://sourceforge.net/projects/yoshimi/)
	- https://sourceforge.net/projects/yoshimi/
	![img](https://linuxsynths.com/YoshimiBanksDemos/AddSynth01.png)
- [ZynAddSubFX](https://sourceforge.net/projects/zynaddsubfx/)
	- https://sourceforge.net/projects/zynaddsubfx/
	![img](https://zynaddsubfx.sourceforge.io/images/zyn-fusion-add.png)

#### 模块化合成器 Modular Synthesizers

**特点**：由独立的模块（如振荡器、滤波器、包络等）组成，用户可以自由连接这些模块，构建自定义的信号路径，提供高度的灵活性和创造性。

**案例**：

- [VCV Rack](https://github.com/VCVRack/Rack) - 免费的虚拟模块化合成器平台，模拟Eurorack系统，拥有丰富的第三方模块支持。
	- https://github.com/VCVRack/Rack


## 效果器VST  

**效果器（Audio Effects）** 是音频处理中的关键工具，它们基于 **数字信号处理（DSP, Digital Signal Processing）**，用于改变音频的频率特性、动态范围、空间感等。以下介绍常见的效果器算法，并结合真实音乐制作中的应用案例，帮助理解其作用和实现方式。

### 均衡器 EQ, Equalization
**作用**: 调整音频信号的不同频率成分，使音色更加均衡或突出特定部分。

#### 主要算法
- **IIR 滤波器**（如 Biquad、Butterworth）：计算量小，适用于实时均衡。
- **FIR 滤波器**：相位响应更稳定，但计算量较大，适用于高精度处理。
- **FFT 频率均衡**：直接在频域上调整振幅，可用于复杂的图形均衡器。

#### 真实应用
- **流行音乐**：许多流行歌曲在制作过程中都会使用 EQ 来增强人声清晰度，例如提升 3-5kHz 频段，使声音更加明亮。
- **现场演出**：在音乐会或演唱会中，EQ 常用于抑制反馈和优化不同乐器的音色，以适应不同的环境。

### 压缩器 Compressor
**作用**: 调整音频的动态范围，使响亮部分降低、安静部分增强，使声音更加均衡。

#### 主要算法
- **峰值检测（Peak Detection）**：适用于处理瞬态信号（如鼓声）。
- **RMS 计算**：用于整体音量感知，使声音更平滑。
- **非线性增益映射**：可实现 Soft-Knee 压缩，使过渡更自然。

#### 真实应用
- **广播 & 播客**：为了确保主播的声音在节目中保持均匀，不会因为说话音量变化而导致忽大忽小，通常会应用压缩器。
- **鼓组混音**：在摇滚和流行音乐的制作中，压缩器常用于控制鼓的动态，使鼓声更有力、更紧凑。

### 混响 Reverb
**作用**: 模拟声音在不同空间中的反射，使声音更加自然或富有氛围感。

#### 主要算法
- **Schroeder 混响**：使用 All-Pass 滤波器和延迟网络模拟基本房间混响。
- **反馈延迟网络（FDN）**：通过多个反馈延迟叠加，创造更复杂的混响效果。
- **卷积混响（Convolution Reverb）**：使用真实环境的脉冲响应（IR）进行计算，能够还原真实空间的声音特性。

#### 真实应用
- **电影音效**：在电影配乐和音效处理中，混响被用于创造空间感，使角色的声音更符合场景（如大教堂或洞穴）。
- **摇滚音乐**：许多摇滚歌曲的人声或吉他部分都会加入混响，使声音更加丰满，增强空间感。

### 延迟 Delay
**作用**: 让音频信号在一定时间后重复出现，形成回声或节奏性重复效果。

#### 主要算法
- **基础延迟线（Delay Line）**：存储音频信号并延迟播放，形成简单的回声。
- **反馈延迟（Feedback Delay）**：延迟信号部分回传到输入，形成多次回声。
- **BBD（Bucket Brigade Delay）模拟**：模拟老式模拟延迟效果，适用于复古音乐风格。

#### 真实应用
- **电子音乐**：许多电子音乐制作中都会使用节奏同步的延迟效果，使旋律更有层次感和律动感。
- **吉他效果**：在吉他演奏中，延迟被广泛应用，形成 Slapback Delay 或 Ping-Pong Delay 以增加空间感。

### 失真 Distortion
**作用**: 改变音频信号的波形，增加谐波失真，使声音更加“粗糙”或“饱和”。

#### 主要算法
- **软削波（Soft Clipping）**：温和的失真，模拟老式磁带饱和或电子管放大器的声音。
- **硬削波（Hard Clipping）**：更激进的失真，常用于金属音乐和电子音乐。
- **波形整形（Wave Shaping）**：使用非线性映射函数来创造不同风格的失真音色。

#### 真实应用
- **摇滚 & 金属音乐**：在电吉他的音色处理中，失真是必不可少的效果，使音色更具攻击性。

- **电子音乐 & Lo-Fi**：许多电子音乐和 Lo-Fi 风格的音乐会使用模拟饱和或失真效果，使声音听起来更温暖或复古。

### 开源效果器
综合形效果器代表该项目实践了**多个**效果器算法，其中有些项目是对DSP专业知识书籍的实践试手，极具参考价值。
#### 综合型
- [Audio Effect](https://github.com/juandagilc/Audio-Effects)  
	**https://github.com/juandagilc/Audio-Effects**  
	Collection of audio effects plugins implemented from the explanations in the book **Audio Effects: Theory, Implementation and Application** by *Joshua D. Reiss* and *Andrew P. McPherson*.  
	> Delay, Vibrato, Flanger, Chorus, EQ, Wah-Wah, Phaser, Tremolo, Compressor, Distortion
	
![img](https://github.com/juandagilc/Audio-Effects/blob/master/Screenshots/Parametric%20EQ.png?raw=true)
- [Surge](https://github.com/surge-synthesizer/surge)  
	**https://github.com/surge-synthesizer/surge**  
	> Synth + Effect
	
![img](https://surge-synthesizer.github.io/images/manual/Pictures/surge.png)
- [Vital](https://github.com/mtytel/vital)  
	**https://github.com/mtytel/vital**  
	> Synth + Effect
	
![img](https://cdn.shopify.com/s/files/1/0297/3233/9847/files/vital_synth_plugin_free_download.png?v=1691627327)
- [Calf](https://github.com/calf-studio-gear/calf)  
	**https://github.com/calf-studio-gear/calf**  
	> Delay, Reverb, EQ, Distortion, Compressor, Chorus, Phaser, Flanger,
	
![img](http://calf-studio-gear.org/images/plugins/Calf%20-%20Reverb.jpg)
- [VSTPlugins](https://github.com/keithhearne/VSTPlugins)  
	**https://github.com/keithhearne/VSTPlugins**  
	Will Pirkle (2012), **Designing Audio Effect Plug-Ins in C++: With Digital Audio Signal Processing Theory. 1 Edition.** Focal Press.
	> Delay, Reverb
- [pulp-fiction](https://github.com/enter-opy/pulp-fiction)  
	**https://github.com/enter-opy/pulp-fiction**  
	> Delay, Chours, Flanger, Tremelo
	
![img](https://github.com/enter-opy/pulp-fiction/blob/main/res/Screenshot.png?raw=true)
- [zam-plugins](https://github.com/zamaudio/zam-plugins)  
	**https://github.com/zamaudio/zam-plugins**  
	> EQ, Compressor, Distortion, Delay
	
![img](http://www.zamaudio.com/wp-content/uploads/2016/06/zamulticompx2.png)
	
#### 均衡
- [ModEQ](https://github.com/tobanteAudio/modEQ)
	- https://github.com/tobanteAudio/modEQ
	
![img](https://github.com/tobanteAudio/modEQ/blob/master/doc/modEQ_screenshot_plugin.png?raw=true)
- [Mini-Series](https://github.com/DISTRHO/Mini-Series)
	- https://github.com/DISTRHO/Mini-Series
	
![img](https://raw.githubusercontent.com/DISTRHO/mini-series/master/plugins/3BandEQ/Screenshot.png)
#### 压缩
- [Squeezer](https://github.com/mzuther/Squeezer)
	- https://github.com/mzuther/Squeezer
	
![img](https://github.com/mzuther/Squeezer/blob/master/doc/include/images/squeezer.png?raw=true)
#### 混响
- [Cloud Seed](https://github.com/ValdemarOrn/CloudSeed)
	- https://github.com/ValdemarOrn/CloudSeed
	
![img](https://github.com/ValdemarOrn/CloudSeed/blob/master/interface.png?raw=true)
- [MVerb](https://github.com/DISTRHO/MVerb)
	- https://github.com/DISTRHO/MVerb
	
![img](https://raw.githubusercontent.com/DISTRHO/MVerb/master/plugins/MVerb/Screenshot.png)
- [Dragonfly Reverb](https://github.com/michaelwillis/dragonfly-reverb)
	- https://github.com/michaelwillis/dragonfly-reverb
	
![img](https://github.com/michaelwillis/dragonfly-reverb/blob/master/collage.png?raw=true)
- [Reach](https://github.com/Sinuslabs/Reach)
	- https://github.com/Sinuslabs/Reach
	
![img](https://private-user-images.githubusercontent.com/101540156/415853227-519c669f-3996-4917-8d91-e58d87296382.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDE3NDQ0ODgsIm5iZiI6MTc0MTc0NDE4OCwicGF0aCI6Ii8xMDE1NDAxNTYvNDE1ODUzMjI3LTUxOWM2NjlmLTM5OTYtNDkxNy04ZDkxLWU1OGQ4NzI5NjM4Mi5wbmc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUwMzEyJTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MDMxMlQwMTQ5NDhaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1jMTVlZTliNmE1OGZkZmMyOGRkNmM1ZmQ0YTcyZWI1OWZiNjNmZmM4ZDRkYTIzNDNlMWQyOTEyNTFhMzk3ZjBjJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.F2gDmDovFHXWLlMaW8IwQzJDtUDaRTxldj_ay93uh58)
#### 延迟
- [Cocoa Delay](https://github.com/tesselode/cocoa-delay)
	- https://github.com/tesselode/cocoa-delay
	
![img](https://github.com/tesselode/cocoa-delay/blob/master/images/screenshot.png?raw=true)
- [Regrader](https://github.com/igorski/regrader)
	- https://github.com/igorski/regrader
#### 失真
- [CHOW](https://github.com/Chowdhury-DSP/CHOW)
	- https://github.com/Chowdhury-DSP/CHOW
	
![img](https://raw.githubusercontent.com/jatinchowdhury18/CHOW/master/screenshot.PNG)
- [Schrammel OJD](https://github.com/JanosGit/Schrammel_OJD)
	- https://github.com/JanosGit/Schrammel_OJD
	
![img](https://github.com/JanosGit/Schrammel_OJD/blob/master/Documentation/Images/OJD_Cubase.png?raw=true)
- [Sound of Music](https://github.com/enter-opy/sound-of-music)
	- https://github.com/enter-opy/sound-of-music
	
![img](https://github.com/enter-opy/sound-of-music/blob/main/res/Screenshot.png?raw=true)
- [Smart Guitar Pedal](https://github.com/GuitarML/SmartGuitarPedal) - *ML*
	- https://github.com/GuitarML/SmartGuitarPedal
	
![img](https://github.com/GuitarML/SmartGuitarPedal/blob/master/resources/app_pic.png?raw=true)
- [Temper](https://github.com/creativeintent/temper)
	- https://github.com/creativeintent/temper
	
![img](https://raw.githubusercontent.com/creativeintent/temper/refs/heads/master/screenshot.jpg)
- [ScorchCrafter Guitar FX](https://sourceforge.net/projects/scorchcrafter/)
	- https://sourceforge.net/projects/scorchcrafter/
	
![img](https://a.fsdn.com/con/app/proj/scorchcrafter/screenshots/284111.jpg/max/max/1)
#### 合唱
- [YK Chorus](https://github.com/SpotlightKid/ykchorus)
	- https://github.com/SpotlightKid/ykchorus
	
![img](https://github.com/SpotlightKid/ykchorus/blob/master/screenshot.png?raw=true)
	

## 混音 Mixing & 母带 Mastering  

在音乐制作中，**混音（Mixing）** 和 **母带（Mastering）** 是两个关键环节，它们确保音乐作品**清晰、平衡，并符合商业发行的标准**。

- **混音（Mixing）** 处理 **多轨音频**（人声、鼓、吉他、贝斯等），确保它们互相协调，避免频率冲突，使整体听感清晰。  
- **母带（Mastering）** 处理 **最终混音文件**，优化音质，让其适用于各种播放设备，并达到行业标准的响度。  

### 混音阶段 Mixing Stage
**混音的目标** 是将多个音轨整合，使它们在频率、音量、动态范围、空间感等方面协调一致。常见步骤包括：  

#### 增益调整 Gain Staging  
在混音开始前，调整各音轨的输入增益，确保没有音轨过载失真，同时为后续处理留有动态余量。通常在 DAW 里使用 **Fader（推子）** 或 **增益插件**进行调整。

#### 声像 Panning  
调整各音轨在立体声中的位置，使声音更加自然和宽广。例如，主音通常居中，伴奏吉他可以略向左右分散。使用 **等功率（Equal Power Panning）** 或 **线性声像算法** 确保声场均衡。

#### 均衡 EQ  
使用均衡器调整频率分布，避免乐器之间的频率遮蔽。例如，削减低频来清理浑浊感，或者增加 8kHz 以上的高频，让人声音色更明亮。EQ 算法通常基于 **IIR（无限脉冲响应）滤波器** 或 **FIR（有限脉冲响应）滤波器**。

#### 动态处理 Compression 
压缩器用于控制音轨的动态范围，使音量变化更加平稳。压缩器的核心算法涉及 **RMS（均方根）检测、Attack/Release 时间计算、Soft Knee 过渡** 等，使声音更具能量感。

#### 混响 & 延迟 Reverb & Delay  
混响用于模拟空间感，使干音听起来更自然。延迟用于增强节奏感或制造立体空间。混响算法常见有 **卷积混响（Convolution Reverb）** 和 **施罗德混响（Schroeder Reverb）**。

#### 饱和 & 失真 Saturation & Distortion
通过磁带饱和或失真，给声音增加温暖感。此类插件常使用 **非线性波形削波（Wave Shaping）** 和 **谐波倍增（Harmonic Exciter）** 算法。

**混音阶段的最终输出** 是一个 **立体声 WAV 文件**（44.1kHz/24-bit 或 48kHz/32-bit）

### 母带阶段 Mastering Stage
**母带处理的目标** 是微调整个混音，使其在不同播放环境（耳机、车载音响、流媒体）下听感一致，并符合行业标准。核心步骤如下：

#### 均衡 Mastering EQ  
微调整体音色，确保低频不过重，高频不过亮。使用 **母带级别的 EQ**，通常只做 **小幅调整（+/- 1~3dB）**，避免破坏混音的原始平衡。

#### 多段压缩 Multiband Compression  
使用多段压缩器分别处理低频、中频、高频的动态，使不同频段的音量更均衡。这通常使用 **FFT 频率分解算法** 来对频率段进行独立处理。

#### 限制器 Limiter  
为了提高音量，使歌曲达到商业发布的标准，使用限制器。限制器基于 **软/硬限幅（Soft/Hard Clipping）、Lookahead 预测** 算法，确保最大音量不会超出 0dBFS。

#### 立体声增强 Stereo Imaging 
通过 **Mid/Side（M/S）处理** 扩宽立体声宽度（如 iZotope Ozone Imager），让音乐听起来更开阔，但不过度扩展，以免兼容性问题。

#### 饱和 & 模拟色彩 Tape Saturation  
通过模拟磁带增强温暖感，使数字音频更有模拟质感。这些插件通常模拟磁带录音机的 **非线性响应和谐波失真**。

#### 响度标准化 Loudness Normalization  
现代流媒体平台（如 Spotify、Apple Music）要求音频符合 **LUFS（Loudness Units Full Scale）** 标准。通常使用 **iZotope Insight、Youlean Loudness Meter** 来测量和优化音量，使其符合 -14 LUFS（Spotify）或 -8 LUFS（电子舞曲）等行业标准。

母带阶段的**最终输出**是 **WAV 44.1kHz/16-bit（CD 质量）、WAV 48kHz/24-bit（流媒体）、MP3 320kbps（网络播放）**。

### 开源Mixing & Mastering VST
#### 综合型
- [ZL-Audio](https://github.com/ZL-Audio)
	- [ZLEqualizer](https://github.com/ZL-Audio/ZLEqualizer): equalizer plugin
		- https://github.com/ZL-Audio/ZLEqualizer
	- [ZLCompressor](https://github.com/ZL-Audio/ZLCompressor): compressor plugin
		- https://github.com/ZL-Audio/ZLCompressor
	- [ZLSplitter](https://github.com/ZL-Audio/ZLSplitter): splitter plugin
		- https://github.com/ZL-Audio/ZLSplitter
	- [ZLWarm](https://github.com/ZL-Audio/ZLWarm): distortion/saturation plugin
		- https://github.com/ZL-Audio/ZLWarm
	- [ZLLMakeup](https://github.com/ZL-Audio/ZLLMakeup): loudness make-up plugin
		- https://github.com/ZL-Audio/ZLLMakeup
	- [ZLLMatch](https://github.com/ZL-Audio/ZLLMatch): loudness matching plugin
		- https://github.com/ZL-Audio/ZLLMatch
	- [ZLInflator](https://github.com/ZL-Audio/ZLInflator): distortion/saturation plugin
		- https://github.com/ZL-Audio/ZLInflator

![img](https://camo.githubusercontent.com/41f06977a625a0406a7e8aad4465b37b7cee6bbbc71326708b3b7bea479183f3/68747470733a2f2f64726976652e676f6f676c652e636f6d2f75633f6578706f72743d766965772669643d312d686d524e5133353155716337734372745f344a5244314c555f4d6c725a6267)
- [lsp-plugins](https://github.com/lsp-plugins/lsp-plugin)
	- https://github.com/lsp-plugins/lsp-plugin

![IMG](https://lsp-plug.in/img/cover.png)

#### Gain Staging / Limiter
- [JS Inflator](https://github.com/Kiriki-liszt/JS_Inflator)
	- https://github.com/Kiriki-liszt/JS_Inflator
	
![img](https://raw.githubusercontent.com/Kiriki-liszt/JS_Inflator/main/screenshots/screenshot_both.png)
- [PeakEater](https://github.com/vvvar/PeakEater)
	- https://github.com/vvvar/PeakEater
	
![img](https://github.com/vvvar/PeakEater/blob/master/assets/screenshots/screenshot-mac.png?raw=true)
#### Audio Analysis
- [MultiMeter](https://github.com/RealAlexZ/MultiMeter)
	- https://github.com/RealAlexZ/MultiMeter
	
![img](https://private-user-images.githubusercontent.com/97690118/303550604-ce64ecb6-801e-4e9d-8815-1f97655c272d.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDE3NjM4NDksIm5iZiI6MTc0MTc2MzU0OSwicGF0aCI6Ii85NzY5MDExOC8zMDM1NTA2MDQtY2U2NGVjYjYtODAxZS00ZTlkLTg4MTUtMWY5NzY1NWMyNzJkLmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTAzMTIlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwMzEyVDA3MTIyOVomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWM2MDQyNzNjNjgyMjJkNDEwNjc3M2MxZWRiYTI0Njk4MTI4YzE2YTgyYTk5YzE1Y2RlMzVlYTljZTBkYWEyMjgmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.YxAqrUhsbaBYhVw2wGj65uwN9fVmvSj2FDLuEM0JGbU)
- [K-Meter](https://github.com/mzuther/K-Meter)
	- https://github.com/mzuther/K-Meter
	
![img](https://github.com/mzuther/K-Meter/blob/master/doc/include/images/kmeter.png?raw=true)
- [traKmeter](https://github.com/mzuther/traKmeter)
	- https://github.com/mzuther/traKmeter
	
![img](https://github.com/mzuther/traKmeter/blob/master/doc/include/images/trakmeter.png?raw=true)
- [SPARTA](https://github.com/leomccormack/SPARTA)
	- https://github.com/leomccormack/SPARTA
	
![img](https://github.com/leomccormack/SPARTA/blob/master/sparta_screenshot.png?raw=true)
#### Panning
- [binaural](https://github.com/twoz/binaural-vst)
	- https://github.com/twoz/binaural-vst
	
![img](https://raw.githubusercontent.com/twoz/binaural-vst/refs/heads/master/screenshot.png)
#### EQ
- [EQ10Q](https://sourceforge.net/projects/eq10q/) - Parametric EQ
	- https://sourceforge.net/projects/eq10q/

![img](https://a.fsdn.com/con/app/proj/eq10q/screenshots/eq10qs_fft.png/max/max/1)
- [Luftikus](https://github.com/lkjbdsp/lkjb-plugins/tree/master/Luftikus/Source) - Analog-modeled EQ
	- https://github.com/lkjbdsp/lkjb-plugins/tree/master/Luftikus/Source
	
![img](https://static.kvraudio.com/i/b/luftikus_screenshot.png)
- [Frequalizer](https://github.com/ffAudio/Frequalizer)
	- https://github.com/ffAudio/Frequalizer

![img](https://raw.githubusercontent.com/ffAudio/Frequalizer/master/Resources/Screenshot.png)
#### Compressor
- [WIP Compressor Plugin](https://github.com/DGriffin91/compressor-plugin)
	- https://github.com/DGriffin91/compressor-plugin
	
![img](https://github.com/DGriffin91/compressor-plugin/blob/main/demo.png?raw=true)
- [Molot Lite](https://github.com/magnetophon/molot-lite)
	- https://github.com/magnetophon/molot-lite
	
![img](https://www.tokyodawn.net/wp-content/uploads/2020/02/molot03.png)
- [CTAGDRC](https://github.com/p-hlp/CTAGDRC)
	- https://github.com/p-hlp/CTAGDRC
	
![img](https://github.com/p-hlp/CTAGDRC/blob/master/Documentation/CTAGDRC_Snap.png?raw=true)
- [zam-plugins](https://github.com/zamaudio/zam-plugins)  
	- https://github.com/zamaudio/zam-plugins  
	
![img](http://www.zamaudio.com/wp-content/uploads/2016/06/zamulticompx2.png)
	
#### Reverb
- [DF Zita Rev1](https://github.com/SpotlightKid/dfzitarev1)
	- https://github.com/SpotlightKid/dfzitarev1
	
![img](https://github.com/SpotlightKid/dfzitarev1/blob/master/screenshot-carla.png?raw=true)
- [CloudReverb](https://github.com/xunil-cloud/CloudReverb)
	- https://github.com/xunil-cloud/CloudReverb
	
![img](https://github.com/xunil-cloud/CloudReverb/blob/master/screenshots/screenshot_01.png?raw=true)
- [Room Reverb](https://github.com/cvde/RoomReverb)
	- https://github.com/cvde/RoomReverb
	
![img](https://github.com/cvde/RoomReverb/blob/main/Assets/room-reverb-screenshot.png?raw=true)
