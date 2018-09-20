import React, {Component} from 'react';
import $ from 'jquery';
import GroupInput from './group_input';
import GitUrlInput from './git_url_input';
import FlashMessage from '../flash_message';
import DeploymentCard from './deployment_card';

class DeploymentForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      groups: [],
      whitelisted_urls: [],
      deployment: null,
      groupId: "",
      gitUrl: "",
      branch: ""
    }

    this.handleGroupChange = this.handleGroupChange.bind(this);
    this.handleUrlChange = this.handleUrlChange.bind(this);
    this.handleDeployClick = this.handleDeployClick.bind(this);
    // this.urls = JSON.parse(this.props.urls);

    this.connectToDeploymentsChannel();
  }

  componentDidMount() {
    let xhr = new XMLHttpRequest();
    xhr.open('GET', '/api/groups');
    xhr.onload = () => {
      if (xhr.status === 200) {
        let groups = JSON.parse(xhr.responseText).data;
        this.setState({ groups, loading: false });
      }
    };
    xhr.send();
  }

  connectToDeploymentsChannel() {
    let channel = DockupUiSocket.getDeploymentsChannel();

    channel.on("status_updated", (deployment) => {
      this.updateDeployment(deployment);
    })
  }

  updateDeployment(newDeployment) {
    if(this.state.deployment.id == newDeployment.id) {
      this.setState({deployment: Object.assign({}, newDeployment)});
    }
  }

  handleDeployClick(e) {
    this.setState({deployment: null});
    e.preventDefault();
    let xhr = this.createRequest();
    xhr.done((response) => {
      this.setState({deployment: Object.assign({}, response.data)});
    });
    xhr.fail(() => {
      FlashMessage.showMessage("danger", "Deployment cannot be queued.");
    });
  }

  createRequest() {
    return $.ajax({
      url: '/api/deployments',
      type: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({
        git_url: this.state.gitUrl,
        branch: this.state.branch,
        callback_url: null
      })
    });
  }

  handleGroupChange(event) {
    const groupIndex = this.state.groups.findIndex((group) => (
      event.target.value == group.id
    ));

    if (groupIndex > -1) {
      this.setState({ 
        group: this.state.groups[groupIndex].id,
        whitelisted_urls: this.state.groups[groupIndex].whitelisted_urls,
        gitUrl: '',
      });
    } else {
      this.setState({ group: '', whitelisted_urls: [] });
    }
  }

  handleUrlChange(event) {
    const whitelistIndex = this.state.whitelisted_urls.findIndex((whitelist) => (
      event.target.value == whitelist.git_url
    ));

    if (whitelistIndex > -1) {
      this.setState({
        gitUrl: this.state.whitelisted_urls[whitelistIndex].git_url
      });
    } else {
      this.setState({ gitUrl: '' });
    }
  }

  handleBranchChange(branch) {
    this.setState({branch: branch.trim()});
  }

  validInputs() {
    return (this.state.gitUrl.length > 0 && this.state.branch.length > 0);
  }

  renderWhitelistField() {
    if (this.state.group !== '' && this.state.whitelisted_urls.length > 0) {
      return (
        <div className="c-form-group">
          <div className="c-form-control">
            <img className="c-form-icon" src="/icons/icon-git.svg" />
            <select
              value={this.state.gitUrl}
              onChange={this.handleUrlChange}
              className="c-select__input"
              style={{ width: '100%', height: '35px' }}
            >
              <option value="">Select a name</option>
              {
                this.state.whitelisted_urls.map((whitelist) => (
                  <option 
                    key={whitelist.id} 
                    value={whitelist.git_url}
                  >
                    {whitelist.name} - {whitelist.git_url}
                  </option>
                ))
              }
            </select>
          </div>
        </div>
      );
    }

    return null;
  }

  renderDeploymentCard() {
    if(this.state.deployment) {
      return(<DeploymentCard deployment={this.state.deployment}/>);
    }
  }

  render() {
    if (this.state.loading) {
      return <div>Loading...</div>
    }

    return (
      <div className="c-header--dockup">
        <div className="c-container">
          <div className="c-header--dockup-form">
            <form className="c-form">
              <div className="c-form-group">
                <div className="c-form-control">
                  <img className="c-form-icon" src="/icons/icon-git.svg" />
                  <select 
                    value={this.state.group}
                    onChange={this.handleGroupChange}
                    className="c-select__input"
                    style={{ width: '100%', height: '35px' }}
                  >
                    <option value="">Select a group</option>
                    {
                      this.state.groups.map((group) => (
                        <option 
                          key={group.id} 
                          value={group.id}
                        >
                          {group.title}
                        </option>
                      ))
                    }
                  </select>
                </div>
              </div>
              {this.renderWhitelistField()}
              <div className="c-form-group">
                <input className="c-form-control" placeholder="Git branch" id="branch" onChange={
                  (event) => { this.handleBranchChange(event.target.value)}
                } />
                <img className="c-form-icon" src="/icons/icon-branch.svg" />
              </div>
              <div className="u-mt-20">
                <button type="submit" onClick={this.handleDeployClick} disabled={!this.validInputs()} className="c-btn c-btn--primary c-btn--block">Deploy</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    )
  }
}

export default DeploymentForm
