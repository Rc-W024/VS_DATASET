<div align="center">
<img src="https://github.com/user-attachments/assets/e60cada1-b487-44fa-8247-cfc7b7e7df9e" alt="VitalSense"/>

# VitalSense - Example Code for mmWave Vital Signals Dataset
[**A Dataset of 120 GHz Millimeter-Wave Radar Vital Signals With Synchronized Reference Recordings**](https://doi.org/10.1038/s41597-026-07016-6)

![](https://skillicons.dev/icons?i=matlab)
![](https://skillicons.dev/icons?i=cpp)

![](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=flat-square&color=BC4E99)
![](https://img.shields.io/github/license/Rc-W024/VS_DATASET.svg?style=flat-square)
![](https://img.shields.io/badge/GitHub-Rc--W024%2FVS_DATASET-24292F?logo=github&style=flat-square)
![](https://img.shields.io/github/stars/Rc-W024/VS_DATASET?logo=github&label=Stars&color=F2C94C&style=flat-square)

[**Ruochen Wu**](https://futur.upc.edu/32247005) <sup>✉,</sup> $^{\dagger}$
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/42faadef-7999-4130-a4fc-84a467b37e95" alt="CommSensLab" height="15"/> &nbsp; &nbsp;
[Laura Miro](https://futur.upc.edu/37088913)
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/37327f0d-9aaf-4dbf-b161-d12715e94521" alt="SPCOM" height="15"/>,
<img src="https://github.com/user-attachments/assets/f4d75b89-1ad1-4081-a95a-a768955ab762" alt="HUGTiP" height="15"/>
<img src="https://www.germanstrias.org/media/img/igtp-logo-cap-es.svg" alt="IGTP" height="15"/> &nbsp; &nbsp;
[Albert Aguasca](https://futur.upc.edu/179522)
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/42faadef-7999-4130-a4fc-84a467b37e95" alt="CommSensLab" height="15"/>

Cosme Garcia
<img src="https://github.com/user-attachments/assets/f4d75b89-1ad1-4081-a95a-a768955ab762" alt="HUGTiP" height="15"/> &nbsp; &nbsp;
[Antoni Broquetas](https://futur.upc.edu/178234)
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/42faadef-7999-4130-a4fc-84a467b37e95" alt="CommSensLab" height="15"/> &nbsp; &nbsp;
[Montse Najar](https://futur.upc.edu/180118)
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/37327f0d-9aaf-4dbf-b161-d12715e94521" alt="SPCOM" height="15"/>

$\dagger$: These authors contributed equally: **Ruochen Wu**, Laura Miro.

<img width="400" alt="MICIU" src="https://github.com/user-attachments/assets/4d84b669-d7b8-443b-8c18-0168e14cce47"/>

---

**IEEE *DataPort* database:** [**A New Dataset for Millimeter-Wave Radar Vital Sensing With Reference Signals**](https://doi.org/10.21227/wq68-sv85)

**Catalan Open Research Area. Repositori de Dades de Recerca** *(Alternate access)*: [10.34810/data2962](https://doi.org/10.34810/data2962)

<img width=15% alt="image" src="https://upload.wikimedia.org/wikipedia/commons/b/b5/Open_Access_logo_with_dark_text_for_contrast%2C_on_transparent_background.png"/>
</div>

## Instraction
### Dataset
The file structure is
```
VITALSENSE_120_DATASET
├── VS01
│  ├── VS01_Resting.mat
│  ├── VS01_Resting_Mindray.mat
│  ├── VS01_Apnea.mat
│  └── VS01_Apnea_Mindray.mat
...
├── VS24
│  ├── VS24_Resting.mat
│  ├── VS24_Resting_Mindray.mat
│  ├── VS24_Apnea.mat
│  └── VS24_Apnea_Mindray.mat
└── Subject Information.xlsx
   ├── Subject Info
   ├── Radar Parameters 
   └── Reference Parameters
```

The dataset contains measurements from 24 subjects, with a total of 4 minutes per subject across the *Resting* and *Apnea* scenarios. The data and parameters are stored in lightweight `.mat` files that can be read directly in MATLAB, and the entire dataset is about 31 MB.

---

### Code
In this repository you can find the reference code used for the technical validation of breathing and cardiac signals sparation ([`VS_separation`](https://github.com/Rc-W024/VS_DATASET/blob/main/VS_separation.m)) and synchronization study ([`TechValidation`](https://github.com/Rc-W024/VS_DATASET/blob/main/TechValidation.m)). In addition, the script [`PlotVS`](https://github.com/Rc-W024/VS_DATASET/blob/main/PlotVS.m) for data visualization is also included in the repository which can be used by configuring the subject and/or scenarios which shall be viewed.

In particular, this repository also contains the code for the validation of the radar micro-motion sensing part in the paper ([`Test_speaker`](https://github.com/Rc-W024/VS_DATASET/blob/main/Test_speaker.m)), which contains the entire process from the raw beat tone signal to the target displacement signal extraction. The raw data (Loudspeaker) acquired during the test measurement is also included.

The mmWave radar measured data were recorded by means of a high speed digitizer, which is managed by a **C++** based executable. The validation code was written and tested using **MATLAB** *R2024b* for Microsoft Windows.

## FYI
### Paper citation
```bibtex
@article{wu2026dataset,
  title={A dataset of 120 GHz millimeter-wave radar vital signals with synchronized reference recordings},
  author={Wu, Ruochen and Miro, Laura and Aguasca, Albert and Broquetas, Antoni and Garcia, Cosme and Najar, Montse},
  journal={Scientific Data},
  year={2026},
  publisher={Nature Publishing Group UK London}
}
```

### Dataset citation
```bibtex
@data{wq68-sv85-25,
  doi={10.21227/wq68-sv85},
  url={https://doi.org/10.21227/wq68-sv85},
  author={Ruochen Wu and Laura Miro and Antoni Broquetas and Albert Aguasca and Cosme Garcia and Montse Najar},
  publisher={IEEE Dataport},
  title={A New Dataset for Millimeter-Wave Radar Vital Sensing With Reference Signals},
  year={2025}
}
```

---

### Contribution
<div align="center">

⭐️ **Thank you for your interest!** ⭐️

[![](https://img.shields.io/badge/Issues-Report_Bug-red?style=for-the-badge&logo=github)](https://github.com/Rc-W024/VS_DATASET/issues)

[![](https://img.shields.io/github/stars/Rc-W024/VS_DATASET?style=social)](https://github.com/Rc-W024/VS_DATASET/stargazers)
[![](https://img.shields.io/github/forks/Rc-W024/VS_DATASET?style=social)](https://github.com/Rc-W024/VS_DATASET/network/members)

</div>
