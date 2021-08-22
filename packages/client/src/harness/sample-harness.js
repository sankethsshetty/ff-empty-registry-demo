import '../components/page-panel.js';
import '../components/page-body.js';
import '../components/action-card.js';
import '../components/account-widget.js';
import '../components/text-widget.js';
import '../components/number-widget.js';
import '../components/switch-widget.js';

import DappLib from '@decentology/dappstarter-dapplib';
import { LitElement, html, customElement, property } from 'lit-element';

@customElement('sample-harness')
export default class SampleHarness extends LitElement {
	@property()
	title;
	@property()
	category;
	@property()
	description;

	createRenderRoot() {
		return this;
	}

	constructor(args) {
		super(args);
	}

	render() {
		let content = html`
			<page-body
				title="${this.title}"
				category="${this.category}"
				description="${this.description}"
			>
				<!-- Registry -->

				<action-card
					title="Registry - Get Auth NFT"
					description="Register a Tenant with the RegistryService to get an AuthNFT"
					action="receiveAuthNFT"
					method="post"
					fields="signer"
				>
					<account-widget
						field="signer"
						label="Account"
					>
					</account-widget>
				</action-card>

				<action-card
					title="Registry - Has Auth NFT"
					description="Checks to see if an account has an AuthNFT"
					action="hasAuthNFT"
					method="get"
					fields="tenant"
				>
					<account-widget
						field="tenant"
						label="Tenant Account"
					>
					</account-widget>
				</action-card>

				<action-card
					title="RegistryStoneContract - Get Tenant"
					description="Get an instance of a Tenant from RegistryStoneContract to have your own data"
					action="receiveStoneTenant"
					method="post"
					fields="signer"
				>
					<account-widget
						field="signer"
						label="Account"
					>
					</account-widget>
				</action-card>
				<action-card
					title="Registry - Has Stone Tenant"
					description="Checks to see if an account has a Stone Tenant"
					action="hasStoneTenant"
					method="get"
					fields="tenant"
				>
					<account-widget
						field="tenant"
						label="Tenant Account"
					>
					</account-widget>
				</action-card>

				<action-card
					title="RegistryWoodContract - Get Tenant"
					description="Get an instance of a Tenant from RegistryWoodContract to have your own data"
					action="receiveWoodTenant"
					method="post"
					fields="signer"
				>
					<account-widget
						field="signer"
						label="Account"
					>
					</account-widget>
				</action-card>

				<action-card
					title="Registry - Has Wood Tenant"
					description="Checks to see if an account has a Wood Tenant"
					action="hasWoodTenant"
					method="get"
					fields="tenant"
				>
					<account-widget
						field="tenant"
						label="Tenant Account"
					>
					</account-widget>
				</action-card>

				<action-card
					title="User Get Bridge"
					description="User requests a Bridge NFT"
					action="receiveBridge"
					method="post"
					fields="signer"
				>
					<account-widget
						field="signer"
						label="Account"
					>
					</account-widget>
				</action-card>

				<action-card
					title="Registry - Has Bridge"
					description="Checks to see if an account has a bridge"
					action="hasBridge"
					method="get"
					fields="tenant"
				>
					<account-widget
						field="tenant"
						label="Tenant Account"
					>
					</account-widget>
				</action-card>

				<!-- Flow Token -->
				<action-card
					title="Get Balance"
					description="Get the Flow Token balance of an account"
					action="getBalance"
					method="get"
					fields="account"
				>
					<account-widget
						field="account"
						label="Account"
					>
					</account-widget>
				</action-card>
			</page-body>
			<page-panel id="resultPanel"></page-panel>
		`;

		return content;
	}
}
