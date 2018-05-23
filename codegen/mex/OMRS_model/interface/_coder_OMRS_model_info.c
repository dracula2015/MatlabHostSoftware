/*
 * _coder_OMRS_model_info.c
 *
 * Code generation for function '_coder_OMRS_model_info'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "OMRS_model.h"
#include "_coder_OMRS_model_info.h"
#include "OMRS_model_data.h"

/* Function Definitions */
mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xResult;
  mxArray *xEntryPoints;
  const char * fldNames[4] = { "Name", "NumberOfInputs", "NumberOfOutputs",
    "ConstantInputs" };

  mxArray *xInputs;
  const char * b_fldNames[4] = { "Version", "ResolvedFunctions", "EntryPoints",
    "CoverageInfo" };

  xEntryPoints = emlrtCreateStructMatrix(1, 1, 4, fldNames);
  xInputs = emlrtCreateLogicalMatrix(1, 9);
  emlrtSetField(xEntryPoints, 0, "Name", mxCreateString("OMRS_model"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs", mxCreateDoubleScalar(9.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs", mxCreateDoubleScalar(1.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  xResult = emlrtCreateStructMatrix(1, 1, 4, b_fldNames);
  emlrtSetField(xResult, 0, "Version", mxCreateString("9.0.0.341360 (R2016a)"));
  emlrtSetField(xResult, 0, "ResolvedFunctions", (mxArray *)
                emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  emlrtSetField(xResult, 0, "CoverageInfo", covrtSerializeInstanceData
                (&emlrtCoverageInstance));
  return xResult;
}

const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  const char * data[19] = {
    "789ced1d4b6f1b457842d250a4969710509e0d07d42a92b7a512827049fa08719b979ab44d892a676d8fe36df761eddaa92b2e560f8823478efc013873e28054"
    "4e3d82388110ff008178082498d987bd9e2e9ec9ceacbd4ebe951cfb8be79bf99ef3cd37fbed184d145710b99e24afa35f20344ddfc9eb31145c47427882bcde",
    "0ddf83ff4fa1e3217c9fbc2a8eddc4ed66f0a5ad5b184557d5b10c5bb79b9bf71a18b9d873cc3d5cf5bfa91926de342cbcecc480258300d662ecab2e40bf72eb"
    "5eb76764c681e0a27c34508f8fa9043ee6627c3c1dc2db976e5d9cd3d656ae6e94d65de736ae340dc7f6616dbd78717695fcd15cf25fddde3571d0ce72aad82c",
    "58bd71cf70c69dec1b7792c8ccf3f1dee1e04d33f44efb526d954d1c8cdbe6e0bfcfe05378bbb8bc75e9d685398d70bbebead6492a644f5b59d85c5e38af5d7d"
    "ebccd9b775ade93866d9696bd83235d3286b96de34f5b286cd5acbd608f5847996fee984f12762e33f11fe9f5cc74fbdf9dd82047e57eea3c63f15c39f48c047",
    "b1f734ed47addf75cef82798f1295c21cee1160c3229b8b66e16bc8a6eea6e815a7c8faf41fe125df17e23bc8f39f46c30781b69e4415fb33e17da6cc486361b"
    "f011ca26a2279dfd747e3f7d02ec7f1cec7f8733fe69667c0a33f6af371ae6bd0ddf78165bb61f5c8af6baa957a23849c799e78cf314330e856b616fa5ba6e57",
    "4940a0fd7ccae9a7ccf4534e23af44fff87f36e37132a5bd7df5cd39f01791f679d77f56f144761d0571a577e5013f6b3f19973cc133ec31ce1308f590271ce0"
    "75524fbfeae6756af13dbec6374f086413d103f3f9c1b6ff1dcef89027409e90277fc9bbfeb38a27e39f27405c89e31fd43c218d9d5a0de72e76d5d8392f9e2e",
    "31f8149689a74ec3d302fa0b96845dff0376ad66bd94b57e79f3fbebccf81466e677c33bdf32cc66d15e6d59d8352a4399dfb718fcad3472499cdf597664fc00"
    "bdf8fbc36fc10f04da8fda0f78f67a94199fc286473a738db60a7bef70f09719fc6549feb1493e68110741c493b093bf61be3f18767e84199fc2e172662cf73f",
    "29ff21fb32ebf4df1eac837dabb0efacf50beb1958cfe4c10f3a68b0bed751bfbe29acc80f666a66d3ff48e958e2d0f10243078513f76f2eed2af183a1c825d1"
    "0f2236a4ecffcfafd7200ee4c6fe05f43ccfa1e3384307850dcf0ea6ca262d9755b3eee1c9638dc15f4b230f3a1fd48c36ae361c220ead8f0fb9fbbf7fc1fa7e",
    "bcec3e5d3e5b334838a90fc3de2f33f897d3c8e1117b0fe85770ff0aec5db0fde8d6b53d7b9fa919aed7ac1922ebffd7187a284cba2f916e4b35c7351da75172"
    "f6b05b339dbba54a1d57eec8d53f7cc2a16787c1db49239ff8be4e20ae01fc48edebc33e8f60fb2fd160bd7f84faf54ee1acf53e33b841a98ecd4674df8a571f",
    "37d547ff941f3b14e51b865dc5eda2dd14da4f5864fa5b4c2b47268ed01802f163f4fb4559eb779e33be687eb05f7fa9d47517f282e0ca033ec483c1f1204d3e"
    "40bab6f476b6fea12c8fe8bf2fe653ae208f80f59260fbc3ea1fb4286e3cfda35bfe06fe810e5f9e9d363fc8fafe31e403e36de71d3458bfc3ba6fb6c5a1e30d",
    "860e0af39f23e8f139cfe95ff4f901defed236d3cf761a7989d68fcbd7437f0fcf0d88b5cfabde79fbaf2f33745138e17e336e37164cd3a924ea238bfa8b4d06"
    "7f5399bce2ec48d7d9fd017144cd7a69d8fa56104fe21daf3a17827b1349fa48e31fa39b4f12d8928f233fad4e819fa888231fa07ebd5358d57a2bc82c4a24a3",
    "d69ba5a8c834a46b894317d42dedcb9ea06e49b03dcf1f6ea17e3d535875fe51aa3a966ed825ecba8e68ddf511862e0a1b9eaddb82f8b2f65f64f08b9272899e"
    "4f201c44db4cb0cf84469f7f0f4bcf50c70d75dc79f08783140fc8424b183f7ff1809ef3e173a0221ec0794682ed3b281f7a867800f100fca14787a27d56dd2d",
    "445141aece95e707d718bc6b69e432f03c969e8c24f68de03c16c1f61d940f3fd8e1d001e77dc1795f79f29bbceb3fabb892f53a0be2cbc1f2930e1aacefbc3c"
    "3ffd1c430785197f88d2f64cebfc56183a56d2c823d1fe7df265edfec17b18ec5ea47d030dd67356e7dcf1ecfc19665c0ad3f258ab6958d8eb96c276fbcb2a8f",
    "5072ae23e3f78ff0217fff19cebf136ccf5b0fe9a85fdf14ce40df3315c7b2c84add2fec8eff9e01ec3bc1be531efc246ff3222f5e407dc6beec08ea3304dbe7"
    "cd0f78f141e07cecb2a97b85f62eb6e2fb5a69f384a1c827394fa67c683e1ff2eba7bd87f7c11f72e30ffbd037cf1f5e62e8a170923f18b669d8b8c76756f944",
    "7675c0817c023ea4ebbea77fecc03ae920fa8340fee0fb43cbc32517d7e867297fe0d5b3dc64f06e2a964f8c0f15751ce01782ed79797605f5eb9dc219f8c54c"
    "19d3e7a79b75177b75c7ac76e9e3f9c9ab0c7d144ef29378cf59aea36e30f4dc502caf2e1f72e773807f08b6cf5bdc58e2d003f935e4d787c10f7871e115861e",
    "0a337e102d37ba29769671e13a43cf7575f209f9e8894822bffef5f61df00791f6a3ba1fc79baf8f32e352d832abc69e51c5c398ef559f2be3ff4e45487fa191"
    "2c877dd8c7b1f9cf4669dfeaeeff656ddf1d940f3df3d63bcf3374509899e7cd96e7987b7838cf372839972f719e0fd990fbbd929f1d98df85da0fe5f9e7c17a",
    "9e093f9d6b9febd1a5201feeae7b2a7ad93b9ba08f2cee3b67981777d73f3e3f727931d4e109b6cf9bbe79ebf6c93e7a2611415562f76d0e7e36bf6b4da8978b"
    "03c7e03937b1f6a3d62fd419419d11f881cadf1ba7337f8faf5cd7a30e7cee20904d444fca38f0c3e7731007c6c1feb738e3c3b99370eee428fd23af7acf2a6e",
    "64bd7e82f871b8fc6354fb493c3b7e9ca18bc26eb04d3b94fd54d5cf8bd37de6907e0575469d0f7f81df7f166adf41f9d033e4d3904f833ff4e8e0f9c349860e"
    "0a279f3f7cc1b11a7ad32016adc21f46578ffa083b2aea51e17c6ec1f61d940fbf58e2d0f12c43078519bf20bd26cb3d8b75d21506ff4a1ab924fa0361433e4f",
    "f0609da4264f5072ae24274fb8abbb76c933ecdd16c91391b23a0cda2de954aece2ef33cca2303e1aa16482794112baa901305e723fd0b71418d5f8c2a7fe6f9"
    "05d463efcb9ea01e5ba0fd7fabbe49ad", "" };

  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(data, 44568U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/* End of code generation (_coder_OMRS_model_info.c) */
