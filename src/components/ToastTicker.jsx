import React, { useState, useEffect } from 'react';
import cardsData from './cards.json'; // Adjust the path as necessary

const CardStream = () => {
  const [cards, setCards] = useState([]);

  useEffect(() => {
    setCards(cardsData);
  }, []);

  const styles = {
    container: {
      position: 'relative',
      width: '100%',
      height: '100vh',
      overflow: 'hidden',
    },
    card: {
      position: 'absolute',
      right: '10px',
      animation: 'move-up 10s linear infinite',
    },
    cardContent: {
      backgroundColor: '#3B82F6', // Tailwind's blue-500
      color: '#FFFFFF', // Tailwind's text-white
      padding: '1rem', // Tailwind's p-4
      borderRadius: '0.5rem', // Tailwind's rounded
      boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1)', // Tailwind's shadow-lg
    },
  };

  useEffect(() => {
    const styleSheet = document.styleSheets[0];
    const keyframes = `
      @keyframes move-up {
        0% {
          transform: translateY(100%);
        }
        100% {
          transform: translateY(-100vh);
        }
      }
    `;
    styleSheet.insertRule(keyframes, styleSheet.cssRules.length);
  }, []);

  return (
    <div style={styles.container}>
      {cards.map((card, index) => (
        <div
          key={card.id}
          style={{
            ...styles.card,
            animationDelay: `${index * 2}s`,
          }}
        >
          <div style={styles.cardContent}>
            {card.content}
          </div>
        </div>
      ))}
    </div>
  );
};

export default CardStream;
