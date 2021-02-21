import React from 'react';

class Topicos extends React.Component {

    render() {
        return (
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>titulo</th>
                        <th>Mensagem</th>
                        <th>Data Criacao</th>
                    </tr>
                </thead>
                <tbody>
                    {this.props.topicos && this.props.topicos.map(topico => {
                        return <tr>
                            <td>{topico.id}</td>
                            <td>{topico.titulo}</td>
                            <td>{topico.mensagem}</td>
                            <td>{topico.dataCriacao}</td>
                        </tr>
                    })}
                </tbody>
            </table>
        );
    }
}

export default Topicos;