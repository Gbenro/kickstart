import React from 'react';
import {Container} from 'semantic-ui-react';
import Header from './header';
import Head from 'next/head';

export default (props) =>{
    return (
        <Container>
        <head>
        <link rel="stylesheet" 
            href="//cdn.jsdelivr.net/npm/semantic-ui@2.4.0/dist/semantic.min.css"></link>
        </head>
            <Header />
            {props.children}

        </Container>

    );
};