# Example Code for VitalSense Dataset Publication
![](https://skillicons.dev/icons?i=matlab)

![](https://img.shields.io/static/v1?label=%F0%9F%8C%9F&message=If%20Useful&style=flat&color=BC4E99)
![](https://img.shields.io/github/license/Rc-W024/VitalSense2024.svg)

**A New Dataset for Millimeter-Wave Radar Vital Sensing With Reference Signals**

<img width=15% alt="image" src="https://upload.wikimedia.org/wikipedia/commons/b/b5/Open_Access_logo_with_dark_text_for_contrast%2C_on_transparent_background.png"/>

**Link to the IEEE *DataPort* database:** *Coming soon...*

## Info
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

### Code
In this repository you can find the reference code used for the technical validation of breathing and cardiac signals sparation ([`VS_Validation`](https://github.com/Rc-W024/VS_DATASET/blob/main/VS_Validation.m)) and synchronization study ([`SynchValidation`](https://github.com/Rc-W024/VS_DATASET/blob/main/SynchValidation.m)). In addition, the script [`PlotVS`](https://github.com/Rc-W024/VS_DATASET/blob/main/PlotVS.m) for data visualization is also included in the repository which can be used by configuring the subject and/or scenarios which shall be viewed.

The code was written and tested using MATLAB R2024b for Microsoft Windows.

## FYI
### Dataset citation
🚧 *Under Construction...* 🚧

### Paper citation
🚧 *Under Construction...* 🚧
