import { CardProps } from "../../types/CardProps";
import "./card.css";

const Card = (cardprops: CardProps) => {
    const { title, props, slots } = cardprops;

    return (
        <div
            className="card"
            style={
                title === "Informations générales"
                    ? { background: "#C40000" }
                    : {}
            }>
            <h3>{title}</h3>
            <div className="properties">
                {slots
                    ? slots.map((slot, idx) => (
                          <div key={idx} className="slot">
                              <h4>{slot.number}</h4>
                              <div className="properties">
                                  {slot.props.map((prop, idx) => (
                                      <div className="property" key={idx}>
                                          <p>{prop.property}</p>
                                          <p>:</p>
                                          <p>{prop.value}</p>
                                      </div>
                                  ))}
                              </div>
                          </div>
                      ))
                    : props.map((prop, idx) => (
                          <div className="property" key={idx}>
                              <p className="propertyname">{prop.property}</p>
                              <p>:</p>
                              <p>{prop.value}</p>
                          </div>
                      ))}
            </div>
        </div>
    );
};

export default Card;
