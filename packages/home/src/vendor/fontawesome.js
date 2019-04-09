import Vue from 'vue';
import { library } from '@fortawesome/fontawesome-svg-core';
import {
	FontAwesomeIcon,
	FontAwesomeLayers,
	FontAwesomeLayersText
} from '@fortawesome/vue-fontawesome';

Vue.component('font-awesome-icon', FontAwesomeIcon);
Vue.component('font-awesome-layers', FontAwesomeLayers);
Vue.component('font-awesome-layers-text', FontAwesomeLayersText);

import {
	faToolStadmin,
	faToolStagile,
	faToolStcard,
	faToolStdashboard,
	faToolSthome,
	faToolStpivot,
	faToolStprofile,
	faToolStreport,
	faToolStsearch
} from '@stratebi/biserver-customization-common/src/fac/index';

import {
	faAngleDoubleRight,
	faDatabase,
	faFolder,
	faFolderOpen,
	faGlobeEurope,
	faHourglassHalf,
	faLock,
	faPencilAlt,
	faPlus,
	faSave,
	faSearch,
	faSignOutAlt,
	faStar,
	faStore,
	faSync,
	faTimes,
	faTools,
	faUser
} from '@fortawesome/free-solid-svg-icons';

import {
	faCheckSquare,
	faClock,
	faFile,
	faFileAlt,
	faSquare,
	faWindowMaximize
} from '@fortawesome/free-regular-svg-icons';

library.add(
	faAngleDoubleRight,
	faCheckSquare,
	faClock,
	faDatabase,
	faFile,
	faFileAlt,
	faFolder,
	faFolderOpen,
	faGlobeEurope,
	faHourglassHalf,
	faLock,
	faPencilAlt,
	faPlus,
	faSave,
	faSearch,
	faSignOutAlt,
	faSquare,
	faStar,
	faStore,
	faSync,
	faTimes,
	faToolStadmin,
	faToolStagile,
	faToolStcard,
	faToolStdashboard,
	faToolSthome,
	faToolStpivot,
	faToolStprofile,
	faToolStreport,
	faToolStsearch,
	faTools,
	faUser,
	faWindowMaximize
);
