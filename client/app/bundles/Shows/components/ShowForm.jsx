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
    newShow: PropTypes.object,
    errors: PropTypes.object,
    submitting: PropTypes.boolean,
  };

  render() {
    const {formBuilder, submitting, errors} = this.props;
    return (
      <div>
        <ErrorMessages errors={errors} />

        <Tabs bsStyle="pills" defaultActiveKey={1} animation={false}>

          <Tab eventKey={1} title="Basic Info">
            <br/>
            <ShowFormBasic
              formBuilder={formBuilder}
              ref='formBasic'
            />
          </Tab>

          <Tab eventKey={2} title="Cast">
            <br/>
            <ShowFormCast
              formBuilder={formBuilder}
              ref='formCast'
            />
          </Tab>

          <Tab eventKey={3} title="Images">
            <br/>
            <ShowFormImages
              formBuilder={formBuilder}
              ref='formImages'
            />
          </Tab>

          <Tab eventKey={4} title="Videos">
            <br/>
            <ShowFormVideos
              formBuilder={formBuilder}
              ref='formVideos'
            />
          </Tab>

        </Tabs>

        <br/>

        <Grid>
          <Row>
            <Col xs={12} sm={2}>
              {formBuilder.getSubmitButton({disabled: submitting})}
            </Col>
            {this._getDeleteButton()}
          </Row>
        </Grid>

      </div>
    );
  }

  _getDeleteButton() {
    if (!this.props.newShow) {
      return(
        [
          <Col xs={12} smHidden mdHidden lgHidden>
            <br/>
            <br/>
            <br/>
          </Col>
          ,
          <Col xs={12} xsOffset={24} sm={2} smOffset={8}>
            {this.props.formBuilder.getDeleteButton({
              disabled: this.props.submitting
            })}
          </Col>
        ]
      );
    }
    return null;
  }

  getResult() {
    let showToSubmit = {};

    const dataShowBasic = this.refs.formBasic.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowBasic);

    const dataShowCast = this.refs.formCast.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowCast);

    const dataShowImages = this.refs.formImages.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowImages);

    const dataShowVideos = this.refs.formVideos.getResult();
    showToSubmit = _.merge(showToSubmit, dataShowVideos);

    console.log(showToSubmit);
    return showToSubmit;
  }
}
