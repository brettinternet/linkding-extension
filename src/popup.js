import { LitElement, html } from "lit";
import "./popup-form.js";
import { getConfiguration, isConfigurationComplete } from "./configuration.js";
import { LinkdingApi } from "./linkding.js";

export class Popup extends LitElement {
  static properties = {
    hasCompleteConfiguration: { type: Boolean, state: true },
    configuration: { type: Object, state: true },
    api: { type: Object, state: true },
    optionsVisible: { type: Boolean, state: true },
  };

  constructor() {
    super();
    this.hasCompleteConfiguration = true;
    this.configuration = null;
    this.api = null;
    this.optionsVisible = false;
  }

  createRenderRoot() {
    return this;
  }

  firstUpdated(props) {
    super.firstUpdated(props);

    this.init();
  }

  async init() {
    this.configuration = await getConfiguration();
    this.hasCompleteConfiguration = isConfigurationComplete(this.configuration);
    if (this.hasCompleteConfiguration) {
      this.api = new LinkdingApi(this.configuration);
    }
  }

  async handleOptionsSaved() {
    await this.init();
    this.optionsVisible = false;
  }

  render() {
    // Settings render in the popup because Safari opens options pages in a
    // new tab, which dismisses the popup on iOS
    if (!this.hasCompleteConfiguration || this.optionsVisible) {
      return html`
        <ld-options
          .cancelable="${this.hasCompleteConfiguration}"
          @options-saved="${this.handleOptionsSaved}"
          @options-cancel="${() => (this.optionsVisible = false)}"
        ></ld-options>
      `;
    }

    return html`
      <ld-popup-form
        .configuration="${this.configuration}"
        .api="${this.api}"
        @open-options="${() => (this.optionsVisible = true)}"
      ></ld-popup-form>
    `;
  }
}

customElements.define("ld-popup", Popup);
