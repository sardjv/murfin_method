(window.webpackJsonp=window.webpackJsonp||[]).push([[12],{68:function(e,t,n){"use strict";n.r(t),n.d(t,"frontMatter",(function(){return i})),n.d(t,"metadata",(function(){return a})),n.d(t,"rightToc",(function(){return l})),n.d(t,"default",(function(){return p}));var r=n(2),o=n(6),c=(n(0),n(76)),i={id:"quickstart",title:"Quickstart",slug:"quickstart"},a={unversionedId:"quickstart",id:"quickstart",isDocsHomePage:!1,title:"Quickstart",description:".env file",source:"@site/docs/quickstart.md",slug:"/quickstart",permalink:"/murfin_method/docs/quickstart",editUrl:"https://github.com/sardjv/murfin_method/edit/master/docs/docs/quickstart.md",version:"current",sidebar:"someSidebar",next:{title:"Technical Overview",permalink:"/murfin_method/docs/overview"}},l=[{value:".env file",id:"env-file",children:[]},{value:"Booting up",id:"booting-up",children:[{value:"Setup",id:"setup",children:[]},{value:"Start",id:"start",children:[]},{value:"Stop",id:"stop",children:[]}]},{value:"Resolving issues",id:"resolving-issues",children:[]},{value:"Set up Admin user",id:"set-up-admin-user",children:[]},{value:"Logging in",id:"logging-in",children:[]}],u={rightToc:l};function p(e){var t=e.components,n=Object(o.a)(e,["components"]);return Object(c.b)("wrapper",Object(r.a)({},u,n,{components:t,mdxType:"MDXLayout"}),Object(c.b)("h3",{id:"env-file"},".env file"),Object(c.b)("ul",null,Object(c.b)("li",{parentName:"ul"},"To get started, you need a ",Object(c.b)("inlineCode",{parentName:"li"},".env")," file with secrets."),Object(c.b)("li",{parentName:"ul"},"If you use bash, you can generate one with the command:")),Object(c.b)("pre",null,Object(c.b)("code",Object(r.a)({parentName:"pre"},{}),"sh ./script/generate_env_file.sh\n")),Object(c.b)("ul",null,Object(c.b)("li",{parentName:"ul"},"If not, there is an ",Object(c.b)("inlineCode",{parentName:"li"},".env.example")," file included in the repo that you can use, just copy it and remove the ",Object(c.b)("inlineCode",{parentName:"li"},".example")," from the filename. Make sure to change all secrets marked with ",Object(c.b)("strong",{parentName:"li"},"YOU_MUST_CHANGE_THIS_PASSWORD")," before running in production!")),Object(c.b)("h2",{id:"booting-up"},"Booting up"),Object(c.b)("p",null,"If you have Docker on your machine:"),Object(c.b)("h3",{id:"setup"},"Setup"),Object(c.b)("pre",null,Object(c.b)("code",Object(r.a)({parentName:"pre"},{}),"cp docker-compose.override.yml.sample docker-compose.override.yml\ndocker-compose build\n")),Object(c.b)("h3",{id:"start"},"Start"),Object(c.b)("pre",null,Object(c.b)("code",Object(r.a)({parentName:"pre"},{}),"docker-compose up\n")),Object(c.b)("p",null,"It can then be accessed at ",Object(c.b)("a",Object(r.a)({parentName:"p"},{href:"http://localhost:3000/"}),"http://localhost:3000/")),Object(c.b)("h3",{id:"stop"},"Stop"),Object(c.b)("p",null,"Stop containers but do not remove them:"),Object(c.b)("pre",null,Object(c.b)("code",Object(r.a)({parentName:"pre"},{}),"docker-compose stop\n")),Object(c.b)("p",null,"Stop containers and remove not used ones:"),Object(c.b)("pre",null,Object(c.b)("code",Object(r.a)({parentName:"pre"},{}),"docker-compose down --remove-orphans\n")),Object(c.b)("p",null,"Remove all stopped containers, networks not used by at least one container, dangling images and dangling build cache"),Object(c.b)("pre",null,Object(c.b)("code",Object(r.a)({parentName:"pre"},{}),"docker system prune\n")),Object(c.b)("h2",{id:"resolving-issues"},"Resolving issues"),Object(c.b)("p",null,"On first run new file is created:"),Object(c.b)("p",null,Object(c.b)("inlineCode",{parentName:"p"},"script/first_run_complete.tmp")),Object(c.b)("p",null,"In some cases deleting it may help with resolving your running issues."),Object(c.b)("h2",{id:"set-up-admin-user"},"Set up Admin user"),Object(c.b)("p",null,"Run rails console from docker container:"),Object(c.b)("pre",null,Object(c.b)("code",Object(r.a)({parentName:"pre"},{}),"docker-compose run --rm app bundle exec rails c\n")),Object(c.b)("p",null,"Add the user with respective email and password and save."),Object(c.b)("h2",{id:"logging-in"},"Logging in"),Object(c.b)("p",null,"Auth0 or Devise can be used for login. For Auth0, you need to add your ",Object(c.b)("strong",{parentName:"p"},"AUTH0_CLIENT_ID")," and ",Object(c.b)("strong",{parentName:"p"},"AUTH0_CLIENT_SECRET")," to the env file in the Auth0 section."))}p.isMDXComponent=!0},76:function(e,t,n){"use strict";n.d(t,"a",(function(){return s})),n.d(t,"b",(function(){return m}));var r=n(0),o=n.n(r);function c(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){c(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},c=Object.keys(e);for(r=0;r<c.length;r++)n=c[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var c=Object.getOwnPropertySymbols(e);for(r=0;r<c.length;r++)n=c[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var u=o.a.createContext({}),p=function(e){var t=o.a.useContext(u),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},s=function(e){var t=p(e.components);return o.a.createElement(u.Provider,{value:t},e.children)},b={inlineCode:"code",wrapper:function(e){var t=e.children;return o.a.createElement(o.a.Fragment,{},t)}},d=o.a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,c=e.originalType,i=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),s=p(n),d=r,m=s["".concat(i,".").concat(d)]||s[d]||b[d]||c;return n?o.a.createElement(m,a(a({ref:t},u),{},{components:n})):o.a.createElement(m,a({ref:t},u))}));function m(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var c=n.length,i=new Array(c);i[0]=d;var a={};for(var l in t)hasOwnProperty.call(t,l)&&(a[l]=t[l]);a.originalType=e,a.mdxType="string"==typeof e?e:r,i[1]=a;for(var u=2;u<c;u++)i[u]=n[u];return o.a.createElement.apply(null,i)}return o.a.createElement.apply(null,n)}d.displayName="MDXCreateElement"}}]);