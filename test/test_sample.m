function test_suite=test_sample
    % Test sample code

    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions=localfunctions();
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;


function test_success
    assertTrue(true);

function test_convert_str_to_ascii_single
    sample_str = 'test_string';
    sample_res = padarray(double(sample_str), [0 1], 0, 'post');
    utils = dbcollection_utils();
    res = utils.string_ascii.convert_str_to_ascii(sample_str);
    assertEqual(sample_res, res)
