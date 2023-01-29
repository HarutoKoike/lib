# lib


## As of 2023/01/29

```
.
├── README.md
├── examples
│   ├── ex_array_dimension.pro
│   ├── ex_matrix.pro
│   └── ex_stream.pro
├── file_operation
│   ├── IO
│   │   ├── README.md
│   │   ├── io::read_ascii.pro
│   │   ├── io::write_ascii.pro
│   │   └── io__define.pro
│   ├── cdf
│   │   ├── cdf::get.pro
│   │   ├── cdf::get_info.pro
│   │   ├── cdf::print_gatts.pro
│   │   ├── cdf::varinfo.pro
│   │   ├── cdf__define.pro
│   │   └── cdftest.pro
│   └── convert_png.sh
├── general
│   ├── cpath.pro
│   ├── date
│   │   ├── date::convert.pro
│   │   ├── date::format_list.pro
│   │   ├── date::string.pro
│   │   └── date__define.pro
│   ├── idlversion.pro
│   ├── path
│   │   ├── README.md
│   │   ├── path::filename.pro
│   │   ├── path::format_char.pro
│   │   ├── path::format_list.pro
│   │   ├── path::save_format.pro
│   │   └── path__define.pro
│   ├── ptrlib
│   │   ├── README.md
│   │   ├── idlpackage.json
│   │   ├── ptr::delete.pro
│   │   ├── ptr::exists.pro
│   │   ├── ptr::get.pro
│   │   ├── ptr::help.pro
│   │   ├── ptr::list.pro
│   │   ├── ptr::restore.pro
│   │   ├── ptr::save.pro
│   │   ├── ptr::store.pro
│   │   └── ptr__define.pro
│   ├── shell
│   │   └── kill.pro
│   ├── string
│   │   ├── str::contain.pro
│   │   ├── str::join2.pro
│   │   ├── str::replace.pro
│   │   ├── str::split2.pro
│   │   └── str__define.pro
│   └── tools
│       ├── tools::is_samesize.pro
│       ├── tools__define.pro
│       └── usage.pro
├── mission
│   ├── cluster
│   │   ├── README.md
│   │   ├── analysis
│   │   │   ├── cl_calc_joule.pro
│   │   │   ├── cl_dd6_test.pro
│   │   │   ├── cl_fote_plot.pro
│   │   │   ├── cl_psd_plot.pro
│   │   │   ├── cl_test.pro
│   │   │   ├── cl_walen_test.pro
│   │   │   ├── cluster::plot_fieldline3d.pro
│   │   │   └── cluster::walen_test.pro
│   │   ├── background
│   │   │   ├── cl_tplot_names.pro
│   │   │   ├── cluster::authentication.pro
│   │   │   ├── cluster::combine_multi.pro
│   │   │   ├── cluster::const.pro
│   │   │   ├── cluster::download.pro
│   │   │   ├── cluster::file_search.pro
│   │   │   ├── cluster::input.pro
│   │   │   ├── cluster__define.pro
│   │   │   └── myfile_untar.pro
│   │   ├── cl_load.pro
│   │   ├── example
│   │   │   └── cl_fote.pro
│   │   ├── instruments
│   │   │   ├── aux
│   │   │   │   ├── aux::constellation.pro
│   │   │   │   ├── aux::distance.pro
│   │   │   │   ├── aux::load.pro
│   │   │   │   ├── aux::plot_configuration.pro
│   │   │   │   └── aux__define.pro
│   │   │   ├── cis
│   │   │   │   ├── ;
│   │   │   │   ├── cis::instrument.pro
│   │   │   │   ├── cis::load.pro
│   │   │   │   ├── cis::plot_psd.pro
│   │   │   │   ├── cis::slice2d_plot.pro
│   │   │   │   └── cis__define.pro
│   │   │   ├── edi
│   │   │   │   ├── edi::load.pro
│   │   │   │   └── edi__define.pro
│   │   │   ├── efw
│   │   │   │   ├── efw::load.pro
│   │   │   │   └── efw__define.pro
│   │   │   ├── fgm
│   │   │   │   ├── fgm::curlometer.pro
│   │   │   │   ├── fgm::fote.pro
│   │   │   │   ├── fgm::load.pro
│   │   │   │   └── fgm__define.pro
│   │   │   ├── peace
│   │   │   │   ├── peace::load.pro
│   │   │   │   └── peace__define.pro
│   │   │   ├── staff
│   │   │   │   ├── staff::load.pro
│   │   │   │   └── staff__define.pro
│   │   │   └── whisper
│   │   │       └── whisper__define.pro
│   │   └── misc
│   │       ├── conv_unit.pro
│   │       ├── myplot_routines.pro
│   │       ├── plasma_parameters.pro
│   │       ├── tmax.pro
│   │       ├── tmean.pro
│   │       └── ts_extract.pro
│   └── dmsp
│       ├── README.md
│       ├── background
│       │   ├── aacgm_dummy.pro
│       │   ├── compile_aacgm.pro
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
│       │   └── format_ssm_MFR.sav
│       ├── dmsp_load.pro
│       └── vizualize
│           └── dmsp_convection.pro
├── plot
│   ├── hpl::fieldline3d.pro
│   ├── hpl::psplot.pro
│   ├── hpl__define.pro
│   ├── idlplotlib::field_line2d.pro
│   ├── idlplotlib::horizontal_error.pro
│   ├── idlplotlib::plot_circle.pro
│   ├── idlplotlib::polar_fill.pro
│   ├── idlplotlib::psym.pro
│   ├── mycolorbar.pro
│   └── vizualize
│       ├── ;
│       ├── coulomb_electric_field.pro
│       └── harris_currentsheet.pro
├── science
│   ├── math
│   │   ├── math::dht_frame.pro
│   │   ├── math::fote.pro
│   │   ├── math::in_range.pro
│   │   ├── math::remove_outlier.pro
│   │   ├── math::walen_test.pro
│   │   └── math__define.pro
│   ├── plasma
│   │   ├── convert_unit.pro
│   │   ├── plasma::palameters.pro
│   │   └── plasma__define.pro
│   └── test_particle
│       ├── particle::plot.pro
│       ├── particle::rk4.pro
│       ├── particle__define.pro
│       └── testparticle.pro
└── spedas
    ├── myspedas::dht_velocity.pro
    ├── myspedas::sh_method.pro
    ├── myspedas::timespan.pro
    ├── myspedas::tmax.pro
    ├── myspedas::tmean.pro
    ├── myspedas::tmva.pro
    ├── myspedas::trange_clip.pro
    ├── myspedas::trotate.pro
    ├── myspedas::twalen_test.pro
    ├── myspedas__define.pro
    └── mytimespan.pro

36 directories, 149 files

```
