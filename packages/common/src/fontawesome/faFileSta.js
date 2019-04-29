import getFaUnicodeCharacter from './getUnicodeCharacter';

import { width, height, ligatures, svgPathData } from './faToolStagile';
export { width, height, ligatures, svgPathData };

export const prefix = 'fac';
export const iconName = 'file-sta';
export const unicode = getFaUnicodeCharacter();

export const definition = {
	prefix: prefix,
	iconName: iconName,
	icon: [width, height, ligatures, unicode, svgPathData]
};

export { definition as faFileSta };