import { getStorageItem, isSafari, setStorageItem } from "./browser";

const CONFIG_KEY = "ld_ext_config";
const DEFAULTS = {
  baseUrl: "",
  token: "",
  default_tags: "",
  useBrowserMetadata: false,
  runSinglefile: false,
  precacheEnabled: false,
  // The iOS popup is a sheet that otherwise has to be dismissed manually
  closeAddBookmarkWindowOnSave: isSafari(),
  closeAddBookmarkWindowOnSaveMs: 500,
};

export async function getConfiguration() {
  const configJson = await getStorageItem(CONFIG_KEY);
  const config = configJson ? JSON.parse(configJson) : {};
  return {
    ...DEFAULTS,
    ...config,
  };
}

export async function saveConfiguration(config) {
  const configJson = JSON.stringify(config);
  await setStorageItem(CONFIG_KEY, configJson);
}

export function isConfigurationComplete(config) {
  return config.baseUrl && config.token;
}
