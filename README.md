# lib


## List
```
 .
├── IO
│   ├── README.md
│   ├── io::read_ascii.pro
│   ├── io::write_ascii.pro
│   └── io__define.pro
├── README.md
├── basic
│   ├── date
│   │   ├── date::format_list.pro
│   │   ├── date::string.pro
│   │   └── date__define.pro
│   ├── import.pro
│   ├── ptrlib
│   │   ├── README.md
│   │   ├── idlpackage.json
│   │   ├── ptr::delete.pro
│   │   ├── ptr::get.pro
│   │   ├── ptr::help.pro
│   │   ├── ptr::list.pro
│   │   ├── ptr::restore.pro
│   │   ├── ptr::save.pro
│   │   ├── ptr::store.pro
│   │   └── ptr__define.pro
│   └── string
│       ├── str::contain.pro
│       ├── str::replace.pro
│       └── str__define.pro
├── mission
│   ├── cluster
│   │   ├── README.md
│   │   ├── all
│   │   │   ├── cl_all_cis.pro
│   │   │   └── cl_all_fgm.pro
│   │   ├── analysis
│   │   │   ├── buff.pro
│   │   │   ├── cl_load_vars.pro
│   │   │   ├── dc2_fig.pro
│   │   │   ├── event_plot.pro
│   │   │   ├── idl.dat
│   │   │   ├── idlsave.dat
│   │   │   ├── image
│   │   │   │   ├── assymmetric_param.eps
│   │   │   │   ├── ion_density_ratio.eps
│   │   │   │   ├── lr1d-dist_2002031814_outflow.ps
│   │   │   │   ├── lr1d-dist_2002031814_sphere.ps
│   │   │   │   ├── lr1d-dist_2002031815_sheath.ps
│   │   │   │   ├── lr1d-dist_2002112010_outflow.ps
│   │   │   │   ├── lr1d-dist_2002112010_sheath.ps
│   │   │   │   ├── lr1d-dist_2002112010_sphere.ps
│   │   │   │   ├── lr1d-dist_2002112716_outflow.ps
│   │   │   │   ├── lr1d-dist_2002112716_sheath.ps
│   │   │   │   ├── lr1d-dist_2002112716_sphere.ps
│   │   │   │   ├── lr1d-dist_2002121907_outflow.ps
│   │   │   │   ├── lr1d-dist_2002121907_sheath.ps
│   │   │   │   ├── lr1d-dist_2002121907_sphere.ps
│   │   │   │   ├── lr1d-dist_2003031915_outflow.ps
│   │   │   │   ├── lr1d-dist_2003031915_sheath.ps
│   │   │   │   ├── lr1d-dist_2003031915_sphere.ps
│   │   │   │   ├── lr1d-dist_2003050604_outflow.ps
│   │   │   │   ├── lr1d-dist_2003050604_sheath.ps
│   │   │   │   ├── lr1d-dist_2003050604_sphere.ps
│   │   │   │   ├── lr1d-dist_2004022715_outflow.ps
│   │   │   │   ├── lr1d-dist_2004022715_sheath.ps
│   │   │   │   ├── lr1d-dist_2004022715_sphere.ps
│   │   │   │   ├── lr1d-dist_2004031012_outflow.eps
│   │   │   │   ├── lr1d-dist_2004031012_outflow.ps
│   │   │   │   ├── lr1d-dist_2004031012_sheath.eps
│   │   │   │   ├── lr1d-dist_2004031012_sheath.ps
│   │   │   │   ├── lr1d-dist_2004031012_sphere.eps
│   │   │   │   ├── lr1d-dist_2004031012_sphere.ps
│   │   │   │   ├── lr1d-dist_2004041219_outflow.ps
│   │   │   │   ├── lr1d-dist_2004041219_sheath.ps
│   │   │   │   ├── lr1d-dist_2004041219_sphere.ps
│   │   │   │   ├── lr1d-dist_2004042204_sheath.ps
│   │   │   │   ├── lr1d-dist_2004042205_outflow.ps
│   │   │   │   ├── lr1d-dist_2004042205_sphere.ps
│   │   │   │   ├── lr2d-dist_2002031814_outflow.eps
│   │   │   │   ├── lr2d-dist_2002031814_outflow.ps
│   │   │   │   ├── lr2d-dist_2002031814_sphere.eps
│   │   │   │   ├── lr2d-dist_2002031814_sphere.ps
│   │   │   │   ├── lr2d-dist_2002031815_sheath.eps
│   │   │   │   ├── lr2d-dist_2002031815_sheath.ps
│   │   │   │   ├── lr2d-dist_2002112010_outflow.eps
│   │   │   │   ├── lr2d-dist_2002112010_outflow.ps
│   │   │   │   ├── lr2d-dist_2002112010_sheath.eps
│   │   │   │   ├── lr2d-dist_2002112010_sheath.ps
│   │   │   │   ├── lr2d-dist_2002112010_sphere.eps
│   │   │   │   ├── lr2d-dist_2002112010_sphere.ps
│   │   │   │   ├── lr2d-dist_2002112716_outflow.eps
│   │   │   │   ├── lr2d-dist_2002112716_outflow.ps
│   │   │   │   ├── lr2d-dist_2002112716_sheath.eps
│   │   │   │   ├── lr2d-dist_2002112716_sheath.ps
│   │   │   │   ├── lr2d-dist_2002112716_sphere.eps
│   │   │   │   ├── lr2d-dist_2002112716_sphere.ps
│   │   │   │   ├── lr2d-dist_2002121907_outflow.eps
│   │   │   │   ├── lr2d-dist_2002121907_outflow.ps
│   │   │   │   ├── lr2d-dist_2002121907_sheath.eps
│   │   │   │   ├── lr2d-dist_2002121907_sheath.ps
│   │   │   │   ├── lr2d-dist_2002121907_sphere.eps
│   │   │   │   ├── lr2d-dist_2002121907_sphere.ps
│   │   │   │   ├── lr2d-dist_2003031915_outflow.eps
│   │   │   │   ├── lr2d-dist_2003031915_outflow.ps
│   │   │   │   ├── lr2d-dist_2003031915_sheath.eps
│   │   │   │   ├── lr2d-dist_2003031915_sheath.ps
│   │   │   │   ├── lr2d-dist_2003031915_sphere.eps
│   │   │   │   ├── lr2d-dist_2003031915_sphere.ps
│   │   │   │   ├── lr2d-dist_2003050604_outflow.eps
│   │   │   │   ├── lr2d-dist_2003050604_outflow.ps
│   │   │   │   ├── lr2d-dist_2003050604_sheath.eps
│   │   │   │   ├── lr2d-dist_2003050604_sheath.ps
│   │   │   │   ├── lr2d-dist_2003050604_sphere.eps
│   │   │   │   ├── lr2d-dist_2003050604_sphere.ps
│   │   │   │   ├── lr2d-dist_2004022715_outflow.eps
│   │   │   │   ├── lr2d-dist_2004022715_outflow.ps
│   │   │   │   ├── lr2d-dist_2004022715_sheath.eps
│   │   │   │   ├── lr2d-dist_2004022715_sheath.ps
│   │   │   │   ├── lr2d-dist_2004022715_sphere.eps
│   │   │   │   ├── lr2d-dist_2004022715_sphere.ps
│   │   │   │   ├── lr2d-dist_2004031012_outflow.eps
│   │   │   │   ├── lr2d-dist_2004031012_outflow.ps
│   │   │   │   ├── lr2d-dist_2004031012_sheath.eps
│   │   │   │   ├── lr2d-dist_2004031012_sheath.ps
│   │   │   │   ├── lr2d-dist_2004031012_sphere.eps
│   │   │   │   ├── lr2d-dist_2004031012_sphere.ps
│   │   │   │   ├── lr2d-dist_2004041219_outflow.eps
│   │   │   │   ├── lr2d-dist_2004041219_outflow.ps
│   │   │   │   ├── lr2d-dist_2004041219_sheath.eps
│   │   │   │   ├── lr2d-dist_2004041219_sheath.ps
│   │   │   │   ├── lr2d-dist_2004041219_sphere.eps
│   │   │   │   ├── lr2d-dist_2004041219_sphere.ps
│   │   │   │   ├── lr2d-dist_2004042204_sheath.eps
│   │   │   │   ├── lr2d-dist_2004042204_sheath.ps
│   │   │   │   ├── lr2d-dist_2004042205_outflow.eps
│   │   │   │   ├── lr2d-dist_2004042205_outflow.ps
│   │   │   │   ├── lr2d-dist_2004042205_sphere.eps
│   │   │   │   ├── lr2d-dist_2004042205_sphere.ps
│   │   │   │   ├── lrplot_2002031814.eps
│   │   │   │   ├── lrplot_2002031814.ps
│   │   │   │   ├── lrplot_2002112010.eps
│   │   │   │   ├── lrplot_2002112010.ps
│   │   │   │   ├── lrplot_2002112716.eps
│   │   │   │   ├── lrplot_2002112716.ps
│   │   │   │   ├── lrplot_2002121907.eps
│   │   │   │   ├── lrplot_2002121907.ps
│   │   │   │   ├── lrplot_2003031915.eps
│   │   │   │   ├── lrplot_2003031915.ps
│   │   │   │   ├── lrplot_2003050604.eps
│   │   │   │   ├── lrplot_2003050604.ps
│   │   │   │   ├── lrplot_2004022715.eps
│   │   │   │   ├── lrplot_2004022715.ps
│   │   │   │   ├── lrplot_2004031012.eps
│   │   │   │   ├── lrplot_2004031012.ps
│   │   │   │   ├── lrplot_2004041219.eps
│   │   │   │   ├── lrplot_2004041219.ps
│   │   │   │   ├── lrplot_2004042204.eps
│   │   │   │   ├── lrplot_2004042204.ps
│   │   │   │   ├── mag_ratio.eps
│   │   │   │   ├── mag_shear.eps
│   │   │   │   └── shear_flow.eps
│   │   │   ├── lr_analysis.pro
│   │   │   ├── lr_calc.pro
│   │   │   ├── lr_distribution.pro
│   │   │   ├── lr_events.pro
│   │   │   ├── lr_events.sav
│   │   │   ├── lr_events_origin.sav
│   │   │   ├── lr_load.pro
│   │   │   ├── lr_location.pro
│   │   │   ├── lr_pl.pro
│   │   │   ├── lr_slice.pro
│   │   │   ├── omni_ladder.pro
│   │   │   └── omni_plot.pro
│   │   ├── aux
│   │   │   ├── cl_aux::distance.pro
│   │   │   ├── cl_aux::load.pro
│   │   │   ├── cl_aux::plot_config.pro
│   │   │   └── cl_aux__define.pro
│   │   ├── cis
│   │   │   ├── cl_cis::inertial_length.pro
│   │   │   ├── cl_cis::instrument.pro
│   │   │   ├── cl_cis::load.pro
│   │   │   ├── cl_cis::slice2d_plot.pro
│   │   │   ├── cl_cis__define.pro
│   │   │   └── idl.dat
│   │   ├── cl_load.pro
│   │   ├── cluster_startup.pro
│   │   ├── common
│   │   │   ├── cluster::authentication.pro
│   │   │   ├── cluster::barycentre.pro
│   │   │   ├── cluster::common.pro
│   │   │   ├── cluster::common_var.pro
│   │   │   ├── cluster::datestruct.pro
│   │   │   ├── cluster::download.pro
│   │   │   ├── cluster::filesearch.pro
│   │   │   ├── cluster::load_vars.pro
│   │   │   ├── cluster::tplot_names.pro
│   │   │   ├── cluster__define.pro
│   │   │   ├── csa_log
│   │   │   ├── date_routines.pro
│   │   │   ├── idl.dat
│   │   │   └── myfile_untar.pro
│   │   ├── edi
│   │   │   ├── cl_edi::load.pro
│   │   │   └── cl_edi__define.pro
│   │   ├── efw
│   │   │   ├── buffer.tar.gz
│   │   │   ├── cl_efw::load.pro
│   │   │   ├── cl_efw__define.pro
│   │   │   ├── efw_test.pro
│   │   │   └── idl.dat
│   │   ├── fgm
│   │   │   ├── cl_fgm::curlometer.pro
│   │   │   ├── cl_fgm::load.pro
│   │   │   ├── cl_fgm__define.pro
│   │   │   └── idl.dat
│   │   ├── misc
│   │   │   ├── conv_unit.pro
│   │   │   ├── myplot_routines.pro
│   │   │   ├── plasma_parameters.pro
│   │   │   ├── tmax.pro
│   │   │   ├── tmean.pro
│   │   │   ├── tmva.pro
│   │   │   ├── trotate.pro
│   │   │   └── ts_extract.pro
│   │   ├── peace
│   │   │   ├── cl_peace::load.pro
│   │   │   └── cl_peace__define.pro
│   │   ├── plot
│   │   │   ├── step1.ps
│   │   │   ├── step1_fig.pro
│   │   │   ├── step2_fig.pro
│   │   │   ├── step3_fig.pro
│   │   │   ├── step4-2_fig.pro
│   │   │   ├── step4_fig.pro
│   │   │   └── step5_fig.pro
│   │   ├── staff
│   │   │   ├── cl_staff::load.pro
│   │   │   └── cl_staff__define.pro
│   │   └── whisper
│   │       ├── cl_whisper::load.pro
│   │       ├── cl_whisper__define.pro
│   │       ├── idl.dat
│   │       └── test_whi.pro
│   └── dmsp
│       ├── background
│       │   ├── dmsp::download.pro
│       │   ├── dmsp::file_test.pro
│       │   ├── dmsp::filename.pro
│       │   ├── dmsp::fileurl.pro
│       │   ├── dmsp::itemize.pro
│       │   ├── dmsp::load_ssj.pro
│       │   ├── dmsp::load_ssm.pro
│       │   ├── dmsp::plot.pro
│       │   ├── dmsp::tplotvar.pro
│       │   ├── dmsp__define.pro
│       │   ├── format_ssm_MFR.sav
│       │   └── idl.dat
│       ├── dmsp_load.pro
│       └── dmsp_startup.pro
├── path
│   ├── path::file_name.pro
│   ├── path::format_list.pro
│   ├── path::save_format.pro
│   └── path__define.pro
├── plot
│   └── mypsplot.pro
└── vizualize
    └── harris_currentsheet.pro
```
