<div align="center">

# PATIENT COHORT
**A clinical dataset of synchronized 120 GHz mmWave radar and reference vital sign recordings from cardiovascular inpatients**

[Laura Miro](https://futur.upc.edu/37088913) <sup>✉,</sup> $^{\dagger}$
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/37327f0d-9aaf-4dbf-b161-d12715e94521" alt="SPCOM" height="15"/>,
<img src="https://www.germanstrias.org/media/img/igtp-logo-cap-es.svg" alt="IGTP" height="15"/>,
<img src="https://github.com/user-attachments/assets/f4d75b89-1ad1-4081-a95a-a768955ab762" alt="HUGTiP" height="15"/> &nbsp; &nbsp;
**Ruochen Wu** $^{\dagger}$
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/42faadef-7999-4130-a4fc-84a467b37e95" alt="CommSensLab" height="15"/> &nbsp; &nbsp;
[Albert Aguasca](https://futur.upc.edu/179522)
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/42faadef-7999-4130-a4fc-84a467b37e95" alt="CommSensLab" height="15"/>
[Montse Najar](https://futur.upc.edu/180118)
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/37327f0d-9aaf-4dbf-b161-d12715e94521" alt="SPCOM" height="15"/> &nbsp; &nbsp;

[Antoni Broquetas](https://futur.upc.edu/178234)
<img src="https://github.com/user-attachments/assets/cacf370a-b89f-454b-a7b8-55c6d49d3ce8" alt="UPC" height="15"/>
<img src="https://github.com/user-attachments/assets/42faadef-7999-4130-a4fc-84a467b37e95" alt="CommSensLab" height="15"/> &nbsp; &nbsp;
Oriol Estrada
<img src="https://www.germanstrias.org/media/img/igtp-logo-cap-es.svg" alt="IGTP" height="15"/>,
<img src="https://github.com/user-attachments/assets/f4d75b89-1ad1-4081-a95a-a768955ab762" alt="HUGTiP" height="15"/> &nbsp; &nbsp;
Cosme Garcia
<img src="https://github.com/user-attachments/assets/98709c48-0cef-46dc-ae95-68bb756a480f" alt="UAB" height="15"/>
<img src="https://github.com/user-attachments/assets/f4d75b89-1ad1-4081-a95a-a768955ab762" alt="HUGTiP" height="15"/>,
<img src="https://github.com/user-attachments/assets/c4ea5efc-2e8b-4faa-aa9a-b8ef8d9d98a2" alt="CIBERCV" height="15"/>

$\dagger$: These authors contributed equally: **Laura Miro**, Ruochen Wu.

---

🔗 **figshare repository:** https://figshare.com/s/e056be5dd8bfee45dd6c 🔗
</div>

> [!IMPORTANT]
> *The study was approved by the research ethics committee of the Germans Trias i Pujol Hospital (PI-25-228). All research was performed in accordance with relevant guidelines and regulations. Written informed consent was obtained from each participant in accordance with institutional ethical regulations for participation and data sharing.*

## Instruction
### Dataset
*UNDER CONSTRUCTION*

This dataset contains measurements from 15 clinical inpatients, with each participant undergoing multiple 10-minute observation sessions in uncontrolled, real-world scenarios. The radar data consists of raw *.bin* files, while the reference parameters are stored in *.mat* files directly readable in MATLAB. The total dataset size is approximately 87 GB.

> [!NOTE]
> During the measurements, patients may exhibit random movements, speaking, or emotional fluctuations, all of these situations have been documented.

---

### Code
In this repository, we provide the [`VitalSig_HUGTiP`](https://github.com/Rc-W024/VS_DATASET/blob/main/VitalSig_HUGTiP.m) script to extract micro-motion displacement signals from raw radar data (*.bin* files). It contains two-channel signals, where Channel 1 and Channel 2 correspond to the radar-observed vital signal and the synchronously acquired ECG Lead II signal, respectively.

The mmWave radar measured data were recorded by means of a high speed digitizer, which was managed by a C++ based executable. The acquired signals were processed by MathWorks MATLAB *R2020b*.

## FYI
### Paper citation
*COMING SOON...*

### Dataset citation
*COMING SOON...*
