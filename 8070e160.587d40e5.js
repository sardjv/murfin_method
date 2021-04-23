(window.webpackJsonp=window.webpackJsonp||[]).push([[12],{68:function(e,t,n){"use strict";n.r(t),n.d(t,"frontMatter",(function(){return c})),n.d(t,"metadata",(function(){return o})),n.d(t,"rightToc",(function(){return l})),n.d(t,"default",(function(){return s}));var a=n(2),r=n(6),i=(n(0),n(76)),c={id:"quickstart",title:"Quickstart",slug:"quickstart"},o={unversionedId:"quickstart",id:"quickstart",isDocsHomePage:!1,title:"Quickstart",description:".env file",source:"@site/docs/quickstart.md",slug:"/quickstart",permalink:"/murfin_method/docs/quickstart",editUrl:"https://github.com/sardjv/murfin_method/edit/master/docs/docs/quickstart.md",version:"current",sidebar:"someSidebar",next:{title:"Technical Overview",permalink:"/murfin_method/docs/overview"}},l=[{value:".env file",id:"env-file",children:[]},{value:"Booting up",id:"booting-up",children:[]},{value:"Create the first Admin",id:"create-the-first-admin",children:[]},{value:"Set up the FTP Connection",id:"set-up-the-ftp-connection",children:[]},{value:"Create an API Token",id:"create-an-api-token",children:[]},{value:"Use the API",id:"use-the-api",children:[]}],u={rightToc:l};function s(e){var t=e.components,n=Object(r.a)(e,["components"]);return Object(i.b)("wrapper",Object(a.a)({},u,n,{components:t,mdxType:"MDXLayout"}),Object(i.b)("h3",{id:"env-file"},".env file"),Object(i.b)("ul",null,Object(i.b)("li",{parentName:"ul"},"To get started, you need a ",Object(i.b)("inlineCode",{parentName:"li"},".env")," file with secrets."),Object(i.b)("li",{parentName:"ul"},"Generate it with the command ",Object(i.b)("inlineCode",{parentName:"li"},"sh ./script/generate_env_file.sh"),".")),Object(i.b)("h3",{id:"booting-up"},"Booting up"),Object(i.b)("pre",null,Object(i.b)("code",Object(a.a)({parentName:"pre"},{}),"docker-compose up\n")),Object(i.b)("p",null,"It can then be accessed at ",Object(i.b)("a",Object(a.a)({parentName:"p"},{href:"http://localhost:3001/"}),"http://localhost:3001/"),"."),Object(i.b)("h3",{id:"create-the-first-admin"},"Create the first Admin"),Object(i.b)("ul",null,Object(i.b)("li",{parentName:"ul"},'Click "Create an account" and enter your details.'),Object(i.b)("li",{parentName:"ul"},"Admins can access ALL user data so this must be a highly privileged account with a very strong password. You will be immediately logged in."),Object(i.b)("li",{parentName:"ul"},"Any subsequent admin that signs up must be manually approved by an existing admin, via the Admins page, clicking Edit and then Activated and Update User.")),Object(i.b)("h3",{id:"set-up-the-ftp-connection"},"Set up the FTP Connection"),Object(i.b)("ul",null,Object(i.b)("li",{parentName:"ul"},"You need to add the FTP connection details for your trust in order to use the API."),Object(i.b)("li",{parentName:"ul"},'Click "Ftp Credentials".'),Object(i.b)("li",{parentName:"ul"},'Click "New ftp credential".'),Object(i.b)("li",{parentName:"ul"},'Enter your FTP connection details and press "Create Ftp credential".'),Object(i.b)("li",{parentName:"ul"},"This will immediately send a request file to the FTP server ",Object(i.b)("inlineCode",{parentName:"li"},"/In")," directory for the initial seed data."),Object(i.b)("li",{parentName:"ul"},"From this point the API will attempt to fetch and import new data from the FTP server each day at 8am.")),Object(i.b)("h3",{id:"create-an-api-token"},"Create an API Token"),Object(i.b)("ul",null,Object(i.b)("li",{parentName:"ul"},"Each client application requires a Token to use the API."),Object(i.b)("li",{parentName:"ul"},'Click "API Tokens".'),Object(i.b)("li",{parentName:"ul"},'Click "New token".'),Object(i.b)("li",{parentName:"ul"},"Give the token a name to identify which client application will use the token."),Object(i.b)("li",{parentName:"ul"},"Add permissions to give access to the data that the client application requires."),Object(i.b)("li",{parentName:"ul"},"Click Create Token."),Object(i.b)("li",{parentName:"ul"},"You will be able to view the secret token only once. Be very careful with it as it grants unimpeded access to confidential user data."),Object(i.b)("li",{parentName:"ul"},"Securely add to your client application so that it can use the API.")),Object(i.b)("h3",{id:"use-the-api"},"Use the API"),Object(i.b)("ul",null,Object(i.b)("li",{parentName:"ul"},"The API documentation can be viewed at ",Object(i.b)("a",Object(a.a)({parentName:"li"},{href:"http://localhost:3001/api_docs"}),"http://localhost:3001/api_docs"),"."),Object(i.b)("li",{parentName:"ul"},'You can use this page to test the API - click "Authorize" and add a Token.'),Object(i.b)("li",{parentName:"ul"},'Click on an endpoint and click "Try it out" and "Execute" to get a response.')))}s.isMDXComponent=!0},76:function(e,t,n){"use strict";n.d(t,"a",(function(){return p})),n.d(t,"b",(function(){return m}));var a=n(0),r=n.n(a);function i(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function c(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function o(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?c(Object(n),!0).forEach((function(t){i(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):c(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},i=Object.keys(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(a=0;a<i.length;a++)n=i[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var u=r.a.createContext({}),s=function(e){var t=r.a.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):o(o({},t),e)),n},p=function(e){var t=s(e.components);return r.a.createElement(u.Provider,{value:t},e.children)},d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.a.createElement(r.a.Fragment,{},t)}},b=r.a.forwardRef((function(e,t){var n=e.components,a=e.mdxType,i=e.originalType,c=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),p=s(n),b=a,m=p["".concat(c,".").concat(b)]||p[b]||d[b]||i;return n?r.a.createElement(m,o(o({ref:t},u),{},{components:n})):r.a.createElement(m,o({ref:t},u))}));function m(e,t){var n=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var i=n.length,c=new Array(i);c[0]=b;var o={};for(var l in t)hasOwnProperty.call(t,l)&&(o[l]=t[l]);o.originalType=e,o.mdxType="string"==typeof e?e:a,c[1]=o;for(var u=2;u<i;u++)c[u]=n[u];return r.a.createElement.apply(null,c)}return r.a.createElement.apply(null,n)}b.displayName="MDXCreateElement"}}]);