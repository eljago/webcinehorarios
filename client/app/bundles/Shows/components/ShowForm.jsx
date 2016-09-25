'use strict';

import React, { PropTypes } from 'react'
import _ from 'lodash'

import Tabs from 'react-bootstrap/lib/Tabs';
import Tab from 'react-bootstrap/lib/Tab';
import Grid from 'react-bootstrap/lib/Grid';
import Row from 'react-bootstrap/lib/Row';
import Col from 'react-bootstrap/lib/Col';

import ShowFormCast from './ShowFormCast'
import ShowFormBasic from './ShowFormBasic'
import ShowFormImages from './ShowFormImages'
import ShowFormVideos from './ShowFormVideos'

import ErrorMessages from '../../../lib/forms/FormFields/ErrorMessages'

import FormBuilder from '../../../lib/forms/FormBuilder';

export default class ShowForm extends React.Component {
  static propTypes = {
    formBuilder: PropTypes.instanceOf(FormBuilder),
    show: PropTypes.object,
    errors: PropTypes.object,
    submitting: PropTypes.boolean,
  };

  render() {
    return (
      <div>
        <ErrorMessages errors={this.props.errors} />

        <Tabs bsStyle="pills" defaultActiveKey={1} animation={false}>

          <Tab eventKey={1} title="Basic Info">
            <br/>
            <ShowFormBasic
              formBuilder={this.props.formBuilder}
              ref='formBasic'
            />
          </Tab>

          <Tab eventKey={2} title="Cast">
            <br/>
            <ShowFormCast
              formBuilder={this.props.formBuilder}
              ref='formCast'
              images={this.props.show.show_person_roles.map((spr) => {
                return spr.image.smallest.url;
              })}
            />
          </Tab>

          <Tab eventKey={3} title="Images">
            <br/>
            <ShowFormImages
              formBuilder={this.props.formBuilder}
              ref='formImages'
              images={this.props.show.images.map((img) => {
                return img.image.smaller.url;
              })}
            />
          </Tab>

          <Tab eventKey={4} title="Videos">
            <br/>
       
          </Tab>

        </Tabs>

        <br/>

        <Grid>
          <Row>
            <Col xs={12} sm={2}>
              {this.props.formBuilder.getSubmitButton(this.props.submitting)}
            </Col>
            {this._getDeleteButton()}
          </Row>
        </Grid>

      </div>
    );
  }

  _getDeleteButton() {
    if (this.props.show.id) {
      return(
        [
          <Col xs={12} smHidden mdHidden lgHidden>
            <br/>
            <br/>
            <br/>
          </Col>
          ,
          <Col xs={12} xsOffset={24} sm={2} smOffset={8}>
            {this.props.formBuilder.getDeleteButton(this.props.submitting)}
          </Col>
        ]
      );
    }
    return null;
  }

  getResult() {
    let showToSubmit = {}

    const dataShowBasic = this.refs.formBasic.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowBasic);

    const dataShowCast = this.refs.formCast.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowCast);

    const dataShowImages = this.refs.formImages.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowImages);

    const dataShowVideos = this.refs.formVideos.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowVideos);


    if (!_.isEmpty(showToSubmit)) {
      _.merge(showToSubmit, {id: this.props.show.id});
    }

    console.log(showToSubmit);
    return showToSubmit;
  }
}
