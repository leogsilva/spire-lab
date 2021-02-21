import React from 'react';

class KakfaMessageRequest extends React.Component{
    constructor(props) {
        super(props);
        this.state = {
          error: null,
          isLoaded: false,
          items: ""
        };
      }
    
      componentDidMount() {
        fetch("https://api.github.com/users/hacktivist123/repos")
          .then(res => res.json())
          .then(
            (result) => {
              this.setState({
                isLoaded: true,
                items: result
              });
            },
            // Nota: É importante lidar com os erros aqui
            // em vez de um bloco catch() para não recebermos
            // exceções de erros dos componentes.
            (error) => {
              this.setState({
                isLoaded: true,
                error
              });
            }
          )
        }
    
        render() {
            const { error, isLoaded, items } = this.state;
            if (error) {
              return <div>Error: {error.message}</div>;
            } else if (!isLoaded) {
              return <div>Loading...</div>;
            } else {
              return (
                <div>                
                    <textarea value={items.repos} />
                </div>
              
              );
            }
          }
}

export default KakfaMessageRequest;