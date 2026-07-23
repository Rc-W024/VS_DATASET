<div align="center">

# HEALTHY COHORT
[**A dataset of 120 GHz millimeter-wave radar vital signals with synchronized reference recordings**](https://doi.org/10.1038/s41597-026-07016-6)

**Ruochen Wu** <sup>✉,</sup> $^{\dagger}$
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/42faadef-7999-4130-a4fc-84a467b37e95" alt="CommSensLab" height="15"/> &nbsp; &nbsp;
[Laura Miro](https://futur.upc.edu/37088913) $^{\dagger}$
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/37327f0d-9aaf-4dbf-b161-d12715e94521" alt="SPCOM" height="15"/>,
<img src="https://www.germanstrias.org/media/img/igtp-logo-cap-es.svg" alt="IGTP" height="15"/>,
<img src="https://github.com/user-attachments/assets/f4d75b89-1ad1-4081-a95a-a768955ab762" alt="HUGTiP" height="15"/> &nbsp; &nbsp;
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

---

🔗 **IEEE *DataPort* database:** [**A New Dataset for Millimeter-Wave Radar Vital Sensing With Reference Signals**](https://doi.org/10.21227/wq68-sv85) 🔗

**Catalan Open Research Area. Repositori de Dades de Recerca** *(Alternate access)*: [10.34810/data2962](https://doi.org/10.34810/data2962)
</div>

> [!IMPORTANT]
> *The study was approved by the ethics committee of the Universitat Politècnica de Catalunya · BarcelonaTech (Identification code: 2024-028). Informed consent for participation and data sharing was obtained and signed in accordance with the ethical principles governing the study. All data have been fully anonymized, ensuring that no information can be traced back to individual participants.*

## Instruction
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

---

> [!TIP]
> To make the results more persuasive and interpretable, it is highly recommended to calculate RR and HR by applying the same processing methods to both the radar and reference signals, such as inter-beat interval (IBI) based calculation or spectrum based estimation, rather than directly comparing algorithm-derived results to the rate values outputed by the reference monitor, which may introduce algorithmic bias.
> By using a "level playing field" approach ensures that any performance gaps are strictly due to the proposed algorithm itself and original signal quality, eliminating variables such as processing bias or algorithmic mismatch.

## FYI
### Paper citation
```bibtex
@article{wu2026dataset,
  title={A dataset of 120 GHz millimeter-wave radar vital signals with synchronized reference recordings},
  author={Wu, Ruochen and Miro, Laura and Aguasca, Albert and Broquetas, Antoni and Garcia, Cosme and Najar, Montse},
  journal={Scientific Data},
  volume={13},
  number={1},
  pages={741},
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
