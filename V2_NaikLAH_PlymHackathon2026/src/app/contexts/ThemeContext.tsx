import { createContext, useContext, useState, ReactNode, useEffect } from 'react';

export type ThemeColor = 'blue' | 'pink' | 'black';

interface ThemeContextType {
  theme: ThemeColor;
  setTheme: (theme: ThemeColor) => void;
  colors: {
    primary: string;
    primaryHover: string;
    primaryLight: string;
    primaryDark: string;
    secondary: string;
    secondaryLight: string;
    accent: string;
    accentLight: string;
    gradient: string;
    gradientHover: string;
  };
}

const themeColors = {
  blue: {
    primary: 'bg-blue-600',
    primaryHover: 'hover:bg-blue-700',
    primaryLight: 'bg-blue-50',
    primaryDark: 'bg-blue-900',
    secondary: 'bg-cyan-600',
    secondaryLight: 'bg-cyan-50',
    accent: 'bg-indigo-600',
    accentLight: 'bg-indigo-50',
    gradient: 'from-blue-600 to-cyan-600',
    gradientHover: 'from-blue-700 to-cyan-700',
  },
  pink: {
    primary: 'bg-pink-600',
    primaryHover: 'hover:bg-pink-700',
    primaryLight: 'bg-pink-50',
    primaryDark: 'bg-pink-900',
    secondary: 'bg-rose-600',
    secondaryLight: 'bg-rose-50',
    accent: 'bg-fuchsia-600',
    accentLight: 'bg-fuchsia-50',
    gradient: 'from-pink-600 to-rose-600',
    gradientHover: 'from-pink-700 to-rose-700',
  },
  black: {
    primary: 'bg-gray-900',
    primaryHover: 'hover:bg-black',
    primaryLight: 'bg-gray-100',
    primaryDark: 'bg-black',
    secondary: 'bg-gray-700',
    secondaryLight: 'bg-gray-50',
    accent: 'bg-gray-800',
    accentLight: 'bg-gray-100',
    gradient: 'from-gray-900 to-gray-700',
    gradientHover: 'from-black to-gray-800',
  },
};

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setThemeState] = useState<ThemeColor>(() => {
    const saved = localStorage.getItem('app-theme');
    return (saved as ThemeColor) || 'blue';
  });

  useEffect(() => {
    localStorage.setItem('app-theme', theme);
  }, [theme]);

  const setTheme = (newTheme: ThemeColor) => {
    setThemeState(newTheme);
  };

  const colors = themeColors[theme];

  return (
    <ThemeContext.Provider value={{ theme, setTheme, colors }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (context === undefined) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
}
