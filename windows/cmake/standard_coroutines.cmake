# These plugin releases request C++20 but also pass the obsolete /await flag.
# Their C++/WinRT headers choose std::coroutine when __cpp_lib_coroutine is
# defined. Include <coroutine> before those headers instead of silencing STL1011.
function(home_qb_use_standard_coroutines target_name)
  if(MSVC AND TARGET ${target_name})
    get_target_property(plugin_options ${target_name} COMPILE_OPTIONS)
    if(plugin_options)
      list(FILTER plugin_options EXCLUDE REGEX "^/await(:strict)?$")
      set_property(TARGET ${target_name} PROPERTY COMPILE_OPTIONS "${plugin_options}")
    endif()
    target_compile_features(${target_name} PRIVATE cxx_std_20)
    set_target_properties(${target_name} PROPERTIES
      CXX_STANDARD 20 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
    target_compile_options(${target_name} PRIVATE /FIcoroutine)
  endif()
endfunction()
