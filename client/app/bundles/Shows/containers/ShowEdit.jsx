'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
import update from 'react/lib/update';
import ShowForm from '../components/ShowForm'

import {ShowsQueries} from '../../../lib/api/queries'

import FormBuilder from '../../../lib/forms/FormBuilder';
import GetFormSchema from '../data/FormSchema'

export default class ShowEdit extends React.Component {
  static propTypes = {
    defaultShowPersonRole: PropTypes.object,
    defaultVideo: PropTypes.object,
    defaultImage: PropTypes.object,
    show: PropTypes.object,
    genres: PropTypes.array,
    videoTypes: PropTypes.array,
  };

  constructor(props) {
    super(props);
    this.state = {
      submitting: false,
      errors: {},
    };
    this.newShow = _.isNull(this.props.show.id);
    _.bindAll(this, '_handleSubmit');
    this.formBuilder = new FormBuilder(
      GetFormSchema({
        defaultShowPersonRole: props.defaultShowPersonRole,
        defaultImage: props.defaultImage,
        defaultVideo: props.defaultVideo,
        genres: props.genres.map((genre) => {
          return {value: genre.id, label: genre.name};
        }),
        videoTypes: props.videoTypes,
        onDelete: this._onDelete,
        onSubmit: this._handleSubmit
      }),
      props.show
    );
  }

  render() {
    return (
      <ShowForm
        ref='form'
        formBuilder={this.formBuilder}
        newShow={this.newShow}
        errors={this.state.errors}
        submitting={this.state.submitting}
      />
    );
  }

  _handleSubmit() {
    if (this.refs.form) {
      const showToSubmit = this.refs.form.getResult();

      let submitOptions = {
        show: showToSubmit,
        success: (response) => {
          window.location.assign('/admin/shows');
        },
        error: (errors) => {
          this.setState({
            errors: errors,
            submitting: false
          });
        }
      };

      this.setState({submitting: true});
      if (this.newShow) {
        ShowsQueries.submitNewShow(submitOptions);
      }
      else {
        submitOptions = update(submitOptions, {show: {id: {$set: this.props.show.id}}});
        ShowsQueries.submitEditShow(submitOptions);
      }
    }
  }

  _onDelete() {
    this.setState({
      submitting: true
    });
    ShowsQueries.submitDeleteShow({
      showId: this.props.show.id,
      success: (response) => {
        window.location.assign('/admin/shows');
        this.setState({
          submitting: false
        });
      },
      error: (error) => {
        // console.log(error);
        this.setState({
          submitting: false
        });
      }
    });
  }
}
