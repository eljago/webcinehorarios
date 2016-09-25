'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'
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
      errors: {}
    };
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
        onDeleteShow: this._onDelete,
        onSubmitShow: this._handleSubmit
      }),
      props.show
    );
  }

  render() {
    return (
      <ShowForm
        ref='form'
        formBuilder={this.formBuilder}
        show={this.props.show}
        errors={this.state.errors}
        submitting={this.state.submitting}
      />
    );
  }

  _handleSubmit() {
    if (this.refs.form) {
      const showToSubmit = this.refs.form.getResult();

      const submitOptions = {
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
      if (this.props.show.id) {
        ShowsQueries.submitEditShow(submitOptions);
      }
      else {
        ShowsQueries.submitNewShow(submitOptions);
      }
    }
  }

  _onDelete() {
    if (this.props.show.id) {
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
}
