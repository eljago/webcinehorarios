'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import EditShowRow from './EditShowRow'

export default class EditFunctionsMain extends React.Component {
  static propTypes = {
    formBuilders: PropTypes.array,
    submittingShows: PropTypes.boolean,
    onSubmitShows: PropTypes.func,
    offsetDays: PropTypes.number,
  };

  constructor(props) {
    super(props);
    _.bindAll(this, '_onSubmit');
  }

  render() {
    return (
      <form>
        <table className="table table-striped">
          <tbody>
            {this._getFunctions()}
          </tbody>
        </table>
        <button
          className={`btn btn-primary`}
          type='submit'
          disabled={this.props.submittingShows}
          onClick={this._onSubmit}
        >
          Submit
        </button>
      </form>
    );
  }

  _onSubmit(e) {
    this.props.onSubmitShows();
    e.preventDefault();
  }

  _getFunctions() {
    return this.props.formBuilders.map((formBuilder) => {
      return(
        <EditShowRow
          key={formBuilder.object.id}
          ref={`show_${formBuilder.object.id}`}
          formBuilder={formBuilder}
          offsetDays={this.props.offsetDays}
        />
      );
    });
  }

  getResult() {
    let functionsAttributes = [];
    for (const formBuilder of this.props.formBuilders) {
      const show = formBuilder.object;
      const ref = `show_${show.id}`;
      const formElement = this.refs[ref];
      if (formElement && _.isFunction(formElement.getResult)) {
        const result = formElement.getResult();
        if (!_.isEmpty(result)) {
          functionsAttributes = functionsAttributes.concat(result);
        }
      }
    }
    return functionsAttributes;
  }
}
