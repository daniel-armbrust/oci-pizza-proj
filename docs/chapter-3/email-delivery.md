# Email Delivery

Email Delivery é um serviço gerenciado de [SMTP (Simple Mail Transfer Protocol)](https://datatracker.ietf.org/doc/html/rfc5321) oferecido pelo OCI para o envio de e-mails. Qualquer aplicação que necessite enviar e-mails é um candidato ideal para utilizar esse serviço, pois ele atua como um _"servidor de e-mail de saída"_ (outbound email server). No caso da aplicação OCI Pizza, a funcionalidade _"Esqueci minha senha"_ utilizará o Email Delivery para enviar um e-mail ao usuário, permitindo que ele redefina sua senha.

![alt_text](./img/email-delivery-1.png "OCI Pizza - Email Delivery")

>_**__NOTA:__** De acordo com a documentação, o serviço é otimizado para o envio de e-mails em massa, marketing e transacionais, abrangendo comunicações essenciais que incluem alertas de detecção de fraude, verificações de identidade e redefinições de senha. Ele não é destinado ao envio de correspondência pessoal._

Neste capítulo, serão abordados conceitos fundamentais relacionados à entrega de e-mails na Internet, incluindo o Email Delivery. Além disso, o serviço será configurado para que a aplicação OCI Pizza possa utilizá-lo de forma eficaz.

## Email e a Internet

O tema "E-mail e Internet" é complexo e abrange uma variedade de especificações e protocolos que definem a estrutura das mensagens e o processo de transferência delas do remetente ao destinatário.








 gerados por aplicações que necessitam ser entregues para outros servidores SMTPs, são um perfeito caso de uso para o serviço Email Delivery.

- Distinção entre protocolos que enviam e-mail e os que possibilitam ler e-mails.
- SMTP cuida do transporte das mensagens entre servidores SMTPs.

Em marketing, como mencionado anteriormente, supressão se refere à prática de excluir contatos de listas de envio, impedindo que eles recebam determinadas comunicações